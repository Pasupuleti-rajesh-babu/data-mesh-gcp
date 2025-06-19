# Use the official Dataflow base image.
FROM gcr.io/dataflow-templates-base/python3-template-launcher-base

# Set environment variables
ENV FLEX_TEMPLATE_PYTHON_PY_FILE=/template/main.py
ENV FLEX_TEMPLATE_PYTHON_REQUIREMENTS_FILE=/template/requirements.txt

# Copy the pipeline code and dependencies
COPY main.py /template/
COPY requirements.txt /template/

# Install dependencies
RUN pip install --no-cache-dir -r /template/requirements.txt 