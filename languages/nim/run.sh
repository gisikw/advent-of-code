#!/bin/bash
nim c -o:solution solution.nim && \
  ./solution "$@"
