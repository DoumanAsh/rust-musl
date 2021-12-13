FROM rust:alpine3.14

RUN apk add --no-cache \
        musl-dev \
        make \
        git

COPY config.toml /usr/local/cargo/
