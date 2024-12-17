FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y git cmake make g++ bash mesa-common-dev libxext-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /lobster
RUN git clone https://github.com/aardappel/lobster.git . && git checkout tags/v2024.0
RUN cd dev && cmake -DCMAKE_BUILD_TYPE=Release && make -j8

ENV PATH="/lobster/bin:$PATH"
