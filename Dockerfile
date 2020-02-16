FROM python:3.7.6-alpine3.11

ARG LIBRDKAFKA_VERSION=1.3.0

RUN apk add --no-cache \
        bash \
        ca-certificates \
        libressl

COPY requirements.txt /tmp/

RUN apk add --no-cache --virtual .build-deps \
        g++ \
        gcc \
        git \
        libressl \
        libressl-dev \
        linux-headers \
        make \
        musl-dev \
        zlib-dev && \
    wget https://github.com/edenhill/librdkafka/archive/v$LIBRDKAFKA_VERSION.tar.gz \
        -O /tmp/librdkafka-$LIBRDKAFKA_VERSION.tar.gz && \
    cd /tmp/ && \
    tar zxf librdkafka-$LIBRDKAFKA_VERSION.tar.gz && \
    cd librdkafka-$LIBRDKAFKA_VERSION && \
    ./configure && \
    make && \
    make install && \
    cd .. && rm -fr librdkafka-$LIBRDKAFKA_VERSION && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    apk del .build-deps

ENV PYTHONUNBUFFERED 1
CMD ["python"]
