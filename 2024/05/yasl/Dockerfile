FROM debian:stable-slim 

RUN apt-get update && \
    apt-get install -y build-essential cmake libc6-dev git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/yasl-lang/yasl.git && \
    cd yasl && \
    cmake . && \
    cmake --build . && \
    ./install.sh
