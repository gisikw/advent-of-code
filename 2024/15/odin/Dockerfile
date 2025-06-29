FROM debian:stable-slim

ENV ODIN_VERSION="dev-2024-11"
ENV ODIN_ARCHIVE="https://github.com/odin-lang/Odin/archive/refs/tags/${ODIN_VERSION}.tar.gz"
ENV ODIN_ROOT="/usr/local/src/Odin"

RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    llvm-14 \
    llvm-14-dev \
    libstdc++-12-dev \
    wget \
    tar \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src
RUN wget ${ODIN_ARCHIVE} -O odin.tar.gz && \
    tar -xzf odin.tar.gz && \
    mv Odin-${ODIN_VERSION} Odin && \
    rm odin.tar.gz

ENV ODIN_ROOT="/usr/local/src/Odin"

WORKDIR /usr/local/src/Odin
RUN make release-native

RUN ln -s /usr/local/src/Odin/odin /usr/local/bin/odin
