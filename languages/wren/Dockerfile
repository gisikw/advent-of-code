FROM debian:stable-slim AS builder

RUN apt-get update && \
    apt-get install -y wget tar cmake make g++ bash && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /wren
RUN wget https://github.com/wren-lang/wren-cli/archive/refs/tags/0.4.0.tar.gz -O wren-cli.tar.gz && \
    tar -xzf wren-cli.tar.gz

WORKDIR /wren/wren-cli-0.4.0/projects/make

RUN sed -i 's/-m64//g' wren_cli.make

# Patch to support arm64
RUN sed -i '/ifndef config/a\  config=release_$(shell uname -m)' Makefile && \
    sed -i '/else ifeq ($(config),release_32bit)/i\else ifeq ($(config),release_arm64)\n  wren_cli_config = release_64bit' Makefile && \
    sed -i '/else ifeq ($(config),debug_32bit)/i\else ifeq ($(config),debug_arm64)\n  wren_cli_config = debug_64bit' Makefile
RUN sed -i 's/\bwrite\b/wren_write/g' ../../src/cli/vm.c

RUN make config=release_arm64
RUN cp /wren/wren-cli-0.4.0/bin/wren_cli /usr/local/bin/wren_cli
RUN chmod +x /usr/local/bin/wren_cli
