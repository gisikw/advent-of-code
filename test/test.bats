# vim:set ft=bash:

setup() {
  load '/usr/lib/bats/bats-support/load'
  load '/usr/lib/bats/bats-assert/load'

  mkdir -p ./problems/9999/25
  echo "Test" >> ./problems/9999/25/input.txt
  echo "Input" >> ./problems/9999/25/input.txt
  cat > ./problems/9999/25/solutions.yml << EOF
official:
  part1: ""
  part2: ""
examples: []
EOF
}

@test "can run our script" {
  run ./aoc
  assert [ "$status" -eq 1 ]
  assert_output --partial "Usage: ./aoc <command> [<args>]"
}

@test "can execute all language templates" {
  if [ -z "$SPECIFIC_LANG" ]; then
    languages=$(yq '.languages | keys' ./config.yml | sed 's/- //')
  else
    languages=$SPECIFIC_LANG
  fi

  for lang in $languages; do
    CI=1 NOVERIFY=1 run ./aoc new 9999 25 $lang
    CI=1 NOVERIFY=1 run ./aoc run 2
    assert_output --partial "Received 2 lines of input for part 2"
  done
}

teardown() {
  rm -rf ./problems/9999
  rm -rf ./solutions/9999
}
