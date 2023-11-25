_usage() {
  echo "test"
  echo "Run tests"
}

main() {
  # Check if image exists
  if ! docker image ls | grep -q "aoc_bats_img"; then
    echo "Image 'aoc_bats_img' not found. Building it..."
    docker build -t aoc_bats_img ./test
  fi

  # Run the tests using the image
  docker run --rm -it \
    -v "${local_path}:/code" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e AOC_WORKING_DIR="$local_path" \
    aoc_bats_img test
}
