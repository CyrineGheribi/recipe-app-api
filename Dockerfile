FROM python:3.9-alpine3.13
LABEL maintainer="cyrineappdeveloper.com"

ENV PYTHONUNBUFFERED=1

# Install bash and other tools needed for CI (optional but safer)
RUN apk add --no-cache bash git

# Install system dependencies for psycopg2
RUN apk add --no-cache gcc musl-dev postgresql-dev

# Copy requirements and app
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app
EXPOSE 8000

# Install Python venv and dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt -r /tmp/requirements.dev.txt && \
    rm -rf /tmp

# Add venv to PATH
ENV PATH="/py/bin:$PATH"

# Add non-root user
RUN adduser --disabled-password --no-create-home django-user

# Default user
USER django-user

# Default entrypoint (optional)
ENTRYPOINT ["sh", "-c"]
