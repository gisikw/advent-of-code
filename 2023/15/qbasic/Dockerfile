# Start from a base image that includes QEMU
FROM --platform=linux/amd64 ubuntu:latest

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y wget tar \
    gcc \
    libncurses5-dev \
    libtinfo5 \
    libffi-dev \
    libgl1-mesa-dev \
    libx11-dev libxext-dev libxrender-dev libxrandr-dev libxpm-dev

RUN wget http://downloads.sourceforge.net/fbc/FreeBASIC-1.10.0-linux-x86_64.tar.gz -O freebasic.tar.gz
RUN tar -xzf freebasic.tar.gz && rm freebasic.tar.gz
RUN cd FreeBASIC-1.10.0-linux-x86_64 && ./install.sh -i
