#!/usr/bin/env bash

_confirm() {
  if [ -n "${NOVERIFY}" ]; then
    return
  fi
  read -p "$1 [y/N]: " confirmation
  if [[ ! $confirmation =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
  fi
}

_load_env() {
  if [ -f $AOC_TEMPFILE ]; then
    source $AOC_TEMPFILE
  fi
}

usage() {
  echo "Usage: ./aoc <command> [<args>]"
  echo ""
  echo "Available commands:"
  for file in "${local_path}/lib/"[!_]*.sh; do
    source "$file"
    (
      read cmd; read desc;
      printf " %-40s %s\n" "$cmd" "$desc"
    ) <<< "$(_usage)"
  done
  printf " %-40s %s\n" "help" "Display this help message"
  echo ""
  echo "Example:"
  echo "  ./aoc new 2023 01 rust"
  echo ""
}
