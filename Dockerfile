#경량화 리눅스 버전 사용
#미니콘다같은 가상환경 사용

FROM python:3.11-alpine3.19

LABEL maintainer="kenshin753"

# python 0:1 = False:True

ENV PYTHONUNBUFFERED 1

# 경량화를 위해 tmp
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app app


WORKDIR /app
EXPOSE 8000

ARG DEV=False

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    if [ "$DEV" = "True" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"
USER django-user

# Django -Docker - Github - CI/CD