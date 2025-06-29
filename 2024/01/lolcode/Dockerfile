FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    git build-essential cmake libreadline-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch future --single-branch https://github.com/justinmeza/lci.git /lci

WORKDIR /lci
RUN cmake . && make
RUN make install

ENV PATH="/lci:${PATH}"

RUN rm -rf /lci
