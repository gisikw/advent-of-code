#!/bin/sh
gnatmake -o solution solution.adb
./solution "$@"
