FROM debian:stable-slim
RUN apt-get update && apt-get install -y git build-essential

WORKDIR /janet
RUN git clone https://github.com/janet-lang/janet.git .
RUN make && make install
