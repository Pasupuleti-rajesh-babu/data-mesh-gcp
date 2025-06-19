{{
  config(
    materialized='incremental',
    partition_by={
      "field": "event_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by = ["event_type"]
  )
}}

with source as (
    select * from {{ source('marketing_raw', 'marketing_events_raw') }}
)

select
    cast(event_id as string) as event_id,
    cast(event_type as string) as event_type,
    TIMESTAMP(event_timestamp) as event_timestamp,
    cast(campaign_id as string) as campaign_id,
    cast(payload as JSON) as payload,
    loaded_at
from source

{% if is_incremental() %}

  where loaded_at > (select max(loaded_at) from {{ this }})

{% endif %} 