FROM python:3.9-alpine3.13
LABEL maintainer="cyrineappdeveloper.com"

ENV PYTHONUNBUFFERED=1

# Copy requirements and app
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

# Install Python venv, dependencies, and add user
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt -r /tmp/requirements.dev.txt && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Add venv to PATH
ENV PATH="/py/bin:$PATH"

# Run as non-root user
USER django-user
