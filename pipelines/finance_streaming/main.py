import argparse
import json
import logging

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io.gcp.pubsub import ReadFromPubSub
from apache_beam.transforms.window import FixedWindows


def run(project_id, subscription, raw_bucket_path, curated_bucket_path, pipeline_args):
    """The main execution logic of the streaming pipeline."""
    pipeline_options = PipelineOptions(
        pipeline_args, streaming=True, save_main_session=True
    )

    with beam.Pipeline(options=pipeline_options) as p:
        events = (
            p
            | "ReadFromPubSub"
            >> ReadFromPubSub(
                subscription=f"projects/{project_id}/subscriptions/{subscription}",
                with_attributes=False,
            )
            | "Decode" >> beam.Map(lambda x: x.decode("utf-8"))
            | "ParseJSON" >> beam.Map(json.loads)
        )

        # Stage 1: Write Raw to GCS in Avro format
        _ = (
            events
            | "WindowIntoFixedIntervals"
            >> beam.WindowInto(FixedWindows(60))  # 1-minute windows
            | "WriteRawToGCS"
            >> beam.io.WriteToAvro(
                f"gs://{raw_bucket_path}/finance/raw_events",
                file_name_suffix=".avro",
                schema={
                    "fields": [
                        {"name": "event_id", "type": "string"},
                        {"name": "event_type", "type": "string"},
                        {"name": "event_timestamp", "type": "string"},
                        {"name": "user_id", "type": "string"},
                        {"name": "payload", "type": "string"},  # Keep payload as string
                    ]
                },
                use_fastavro=True,
            )
        )

        # Stage 2: Transform and Write Curated to GCS in Parquet format
        def format_for_parquet(element):
            return {
                "event_id": element["event_id"],
                "event_type": element["event_type"],
                "event_timestamp": float(
                    element["event_timestamp"]
                ),  # Convert to float for Parquet timestamp
                "user_id": element["user_id"],
                "payload": json.dumps(
                    element["payload"]
                ),  # Standardize payload to JSON string
            }

        _ = (
            events
            | "FormatForParquet" >> beam.Map(format_for_parquet)
            | "WindowIntoDailyPartitions"
            >> beam.WindowInto(FixedWindows(60 * 60 * 24))  # Daily windows
            | "WriteCuratedToGCS"
            >> beam.io.WriteToParquet(
                f"gs://{curated_bucket_path}/finance/",
                file_name_suffix=".parquet",
                schema=[
                    ("event_id", "STRING"),
                    ("event_type", "STRING"),
                    ("event_timestamp", "TIMESTAMP_MICROS"),
                    ("user_id", "STRING"),
                    ("payload", "STRING"),
                ],
                # TODO: This needs a custom sink to write to date-partitioned paths
                # For now, it writes to the root of the finance folder.
            )
        )


if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)
    parser = argparse.ArgumentParser()
    parser.add_argument("--project_id", required=True, help="GCP Project ID")
    parser.add_argument(
        "--subscription", required=True, help="Pub/Sub subscription name"
    )
    parser.add_argument(
        "--raw_bucket_path",
        required=True,
        help="GCS path for raw data, e.g., project-id-raw",
    )
    parser.add_argument(
        "--curated_bucket_path",
        required=True,
        help="GCS path for curated data, e.g., project-id-curated",
    )
    known_args, pipeline_args = parser.parse_known_args()

    run(
        known_args.project_id,
        known_args.subscription,
        known_args.raw_bucket_path,
        known_args.curated_bucket_path,
        pipeline_args,
    )
