FROM --platform=linux/amd64 ubuntu:latest

WORKDIR /usr/src/app

# Install wget and unzip, and other necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    unzip

RUN wget http://iobin.suspended-chord.info/linux/iobin-linux-x64-deb-current.zip -O iobin.zip
RUN unzip iobin.zip && rm iobin.zip
RUN dpkg -i *.deb
