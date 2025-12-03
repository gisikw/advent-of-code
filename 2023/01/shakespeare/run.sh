#!/bin/bash
python -m pip install shakespearelang
(
  echo "$2"
  cat "$1"
) | shakespeare run solution.spl
