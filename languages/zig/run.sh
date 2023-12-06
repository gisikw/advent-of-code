#!/bin/bash
echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
apk update
apk add zig
zig build-exe solution.zig
./solution "$@"
