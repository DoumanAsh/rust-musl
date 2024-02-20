FROM alpine:latest

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=stable 

RUN set -eux; \
    apk add --no-cache musl-dev make git ca-certificates gcc g++ cmake ;\
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        x86_64) rustArch='x86_64-unknown-linux-musl' ;; \
        aarch64) rustArch='aarch64-unknown-linux-musl' ;; \
        *) echo >&2 "unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.25.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    find $RUSTUP_HOME -type f -executable -exec strip --strip-unneeded {} \; && find $RUSTUP_HOME -name *.so -exec strip --strip-unneeded {} \; && find $RUSTUP_HOME -name *.rlib -exec strip -d {} \; && find $RUSTUP_HOME -name *.a -exec strip -d {} \;
