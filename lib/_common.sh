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

_require_session() {
  local env_file="${local_path}/.env"
  if [ -f "$env_file" ]; then
    source "$env_file"
  else
    echo "Error: .env file not found."
    exit 1
  fi

  if [ -z "${AOC_SESSION}" ]; then
    echo "Error: AOC_SESSION variable not set in .env file."
    exit 1
  fi
}

_setup_problem_dir() {
  local year=$1
  local day=$2
  local problem_dir="${local_path}/problems/${year}/${day}"
  local solutions_file="${problem_dir}/solutions.yml"

  mkdir -p "$problem_dir"

  if [ ! -f "$solutions_file" ]; then
    cat > "$solutions_file" << EOF
official:
  part1: ""
  part2: ""
examples: []
EOF
  fi

  echo "$problem_dir"
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
