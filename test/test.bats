setup() {
  load '/usr/lib/bats/bats-support/load'
  load '/usr/lib/bats/bats-assert/load'
}

@test "can run our script" {
  run ./aoc
  assert [ "$status" -eq 1 ]
  assert_output --partial "Usage: ./aoc <command> [<args>]"
}
