FROM dhi.io/alpine-base:3.24-dev

ARG RUST_VERSION=stable
ARG CARGO_AUDITABLE=0.7.7
# ninja located in some retarded path /usr/lib/ninja-build/bin/ rather than standard bin directory so make sure adjust it
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:/usr/lib/ninja-build/bin/:$PATH \
    RUST_VERSION=$RUST_VERSION \
    RUSTFLAGS="-C link-arg=-fuse-ld=lld" \
    CMAKE_GENERATOR="Ninja"

RUN set -eux; \
    apk add --no-cache musl-dev make git ca-certificates gcc g++ cmake lld ninja-build ;\
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        x86_64) rustArch='x86_64-unknown-linux-musl'; rustupSha256='1552169aba2836777136ccff7a381e95c17233b5d8250cd5e10ae3cb971bfcfc' ;; \
        aarch64) rustArch='aarch64-unknown-linux-musl'; rustupSha256='956deacdc27ab82ae7ac821d5d3e9e95e4795d476d17efe99743bb8531ca1031' ;; \
        ppc64le) rustArch='powerpc64le-unknown-linux-musl'; rustupSha256='334e1e79626a20a31f5cbc4d16e0386b280cc77e46da90bf5db68045b2012a74' ;;\
        riscv64) rustArch='riscv64gc-unknown-linux-musl'; rustupSha256='3d87288288b166938b770e86a96f412b21413465b093ebee1efa71c6b9efd294' ;;\
        *) echo >&2 "unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.29.3/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    rm /usr/local/cargo/env ;\
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    wget https://github.com/rust-secure-code/cargo-auditable/releases/download/v$CARGO_AUDITABLE/cargo-auditable-${rustArch}.tar.xz -O /tmp/cargo-auditable-${rustArch}.tar.xz ;\
    tar -xf /tmp/cargo-auditable-${rustArch}.tar.xz -C $CARGO_HOME/bin/ --strip-components=1 cargo-auditable-${rustArch}/cargo-auditable ;\
    rm /tmp/cargo-auditable-${rustArch}.tar.xz ;\
    chmod +x $CARGO_HOME/bin/cargo-auditable ;\
    find $RUSTUP_HOME -type f -executable -exec strip --strip-unneeded {} \; && find $RUSTUP_HOME -name *.so -exec strip --strip-unneeded {} \; && find $RUSTUP_HOME -name *.rlib -exec strip -d {} \; && find $RUSTUP_HOME -name *.a -exec strip -d {} \;
