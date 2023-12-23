#!/bin/bash
nim c -d:release -o:solution solution.nim && \
  ./solution "$@"
