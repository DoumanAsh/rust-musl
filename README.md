# rust-musl

[![Build](https://github.com/DoumanAsh/rust-musl/actions/workflows/docker-image.yml/badge.svg)](https://github.com/DoumanAsh/rust-musl/actions/workflows/docker-image.yml)
[![Hub](https://img.shields.io/badge/Docker-Hub-2496ed.svg)](https://hub.docker.com/r/douman/rust-musl/tags)

Minimal container to build mostly pure Rust projects using `x86_64-unknown-linux-musl` as default.

## Properties

- `lld` is used as default linked via environment variable `RUSTFLAGS`. This will stop being necessary once default linker shifts to lld on musl targets
- `musl-dev`, `make`, `git` `cmake` and `g++` are installed to provide sufficient baseline for compiling C world dependencies
- `rustup` and all installed binaries are stripped aggressively if necessary

## Tags

Container ship tags with full and short rustc versions

Following tags are provided:

- `latest` - Latest rustc on latest Alpine container
- `<rustc_version>` - Tag with short version
- `<rustc_version>-<alpine_version>` - Tag with rustc short version with alpine tag

## Rebuilt

If you need to rebuild specific version of container feel free to use workflow for this purpose and specify desired version:
https://github.com/DoumanAsh/rust-musl/actions/workflows/docker-image.yml
