# vim:set ft=bash:

setup() {
  load '/usr/lib/bats/bats-support/load'
  load '/usr/lib/bats/bats-assert/load'

  mkdir -p ./problems/9999/99
  echo "Test" >> ./problems/9999/99/input.txt
  echo "Input" >> ./problems/9999/99/input.txt
}

@test "can run our script" {
  run ./aoc
  assert [ "$status" -eq 1 ]
  assert_output --partial "Usage: ./aoc <command> [<args>]"
}

@test "can execute all language templates" {
  yq '.languages | keys' ./config.yml | sed 's/- //' | while read lang; do
    NOVERIFY=1 ./aoc new 9999 99 $lang
    NOVERIFY=1 run ./aoc run 2
    assert_output --partial "Received 2 lines of input for part 2"
  done
}

teardown() {
  rm -rf ./problems/9999
  rm -rf ./solutions/9999
}
