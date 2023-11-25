_usage() {
  echo "run [part]"
  echo "Run a solution"
}

main() {
  _load_env

  # Freeze the image if it hasn't been done already
  frozen_image_file="${local_path}/solutions/$AOC_YEAR/$AOC_DAY/$AOC_LANG/.docker-image-id"
  if [[ ! -f "$frozen_image_file" ]]; then
    docker_image_name=$(yq eval ".languages.$AOC_LANG.container" $local_path/config.yml)
    docker pull $docker_image_name
    image_id=$(docker inspect --format="{{.Id}}" $docker_image_name)
    echo $image_id > $frozen_image_file
  fi
  docker_image_id=$(cat $frozen_image_file)

  # Fetch the run command for the language from the config file
  run_command=$(yq eval ".languages.$AOC_LANG.run" $local_path/config.yml)

  base_path=${AOC_WORKING_DIR:-$local_path}
  problem_path=$base_path/problems/$AOC_YEAR/$AOC_DAY
  solution_path=$base_path/solutions/$AOC_YEAR/$AOC_DAY/$AOC_LANG

  # Execute the solution
  docker run --rm \
    -v $problem_path:/problem \
    -v $solution_path:/solution \
    -w /solution \
    $docker_image_id $run_command /problem/input.txt ${1:-1}
}
