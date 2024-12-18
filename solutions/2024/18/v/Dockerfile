FROM alpine:latest
RUN apk add git alpine-sdk

ENV V_HOME=/usr/local/v
RUN mkdir -p /usr/local && \
    git clone https://github.com/vlang/v /usr/local/v && \
    cd /usr/local/v && make

ENV PATH="/usr/local/v:$PATH"
