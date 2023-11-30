_usage() {
  echo "run [example] [part]"
  echo "Run a solution with an optional example input and part number"
}

main() {
  _load_env
  example_name=$1
  part=${2:-1}
  if [[ $example_name =~ ^[0-9]+$ ]]; then  # If all digits, it's the part number
    part=$example_name
    example_name=""
  fi
  [[ -z "$example_name" ]] && example_name="input"

  _prepare_docker_container
  output_file="/tmp/aoc_output.txt"
  solutions_file="$local_path/problems/$AOC_YEAR/$AOC_DAY/solutions.yml"

  _execute_solution | tee "$output_file"

  output=$(tail -n 1 "$output_file")
  if [[ "$example_name" == "input" ]]; then
    _process_official_output
  else
    _process_example_output
  fi

  rm "$output_file"
}

_prepare_docker_container() {
  frozen_image_file="${local_path}/solutions/$AOC_YEAR/$AOC_DAY/$AOC_LANG/.docker-image-id"
  if [[ ! -f "$frozen_image_file" ]]; then
    docker_image_name=$(yq eval ".languages.$AOC_LANG.container" $local_path/config.yml)
    docker pull $docker_image_name
    docker_image_id=$(docker inspect --format="{{.Id}}" $docker_image_name)
    echo $docker_image_id > $frozen_image_file
  else
    docker_image_id=$(cat $frozen_image_file)
  fi
}

_execute_solution() {
  run_command=$(yq eval ".languages.$AOC_LANG.run" $local_path/config.yml)
  base_path=${AOC_WORKING_DIR:-$local_path}
  problem_path=$base_path/problems/$AOC_YEAR/$AOC_DAY
  solution_path=$base_path/solutions/$AOC_YEAR/$AOC_DAY/$AOC_LANG

  # Execute the solution
  docker run --rm \
    -v $problem_path:/problem \
    -v $solution_path:/solution \
    -w /solution \
    "$docker_image_id" $run_command /problem/${example_name}.txt ${part:-1}
}

_process_example_output() {
  local query=".examples[] | select(.input == \"$example_name.txt\").part$part"
  local known_answer=$(yq e "$query" "$solutions_file")
  if [[ "$output" == "$known_answer" ]]; then
    _output_success
  elif [[ "$known_answer" != "null" ]]; then
    _output_failure "Expected: $known_answer"
  else
    _prompt_to_save_solution
  fi
}

_process_official_output() {
  # Calculate the MD5 hash of the output
  local hash_output=$(echo -n "$output" | md5sum | awk '{print $1}')

  # Retrieve the known hash for this part from solutions.yml
  local known_hash=$(yq e ".official.part${part}" "$solutions_file")

  # Compare the output hash with the known hash
  if [[ "$hash_output" == "$known_hash" ]]; then
    _output_success
  elif [[ -n "$known_hash" && "$known_hash" != "null" ]]; then
    _output_failure "Expected MD5: $known_hash"
  else
    _prompt_to_save_solution
    _prompt_to_submit_solution
  fi
}

_output_success() {
  printf "\033[32m✅ Correct answer!\033[0m\n"
}

_output_failure() {
  printf "\033[31m❌ Incorrect answer. %s\033[0m\n" "$1"
}

_prompt_to_submit_solution() {
  [[ CI -eq 1 ]] && return 0

  _require_session

  echo "Would you like to submit this result? Press [Y] to submit, any other key to skip."
  read -n 1 -s action
  echo  # Add a new line for better readability

  if [[ $action =~ ^[Yy]$ ]]; then
    # Construct the submission URL and data
    local day=${AOC_DAY#0}
    local url="https://adventofcode.com/${AOC_YEAR}/day/${day}/answer"
    local data="level=$part&answer=$output"
    local cookie="session=${AOC_SESSION}"

    # Perform the submission
    local response=$(curl "$url" -s --compressed -X POST \
                      -H "Cookie: $cookie" \
                      --data-raw "$data")

    # Parse the response and determine the outcome
    if [[ "$response" == *"That's the right answer"* ]]; then
      printf "\033[32m✅ Correct answer submitted!\033[0m\n"
      _prompt_to_save_solution
    elif [[ "$response" == *"That's not the right answer"* ]]; then
      printf "\033[31m❌ Incorrect answer submitted.\033[0m\n"
    elif [[ "$response" == *"You gave an answer too recently"* ]]; then
      echo "⏱ Please wait before submitting another answer."
    elif [[ "$response" == *"You don't seem to be solving the right level"* ]]; then
      echo "🚫 Wrong level. Ensure you are submitting for the correct part."
    else
      echo "❓ Unexpected response received."
    fi
  fi
}

_prompt_to_save_solution() {
  [[ CI -eq 1 ]] && return 0
  echo "Would you like to save this result? Press [Y] to save, any other key to skip."
  read -n 1 -s action
  echo  # Add a new line for better readability

  if [[ $action =~ ^[Yy]$ ]]; then
    if [[ "$example_name" == "input" ]]; then
      # Save the MD5 hash for the official input
      local hash_output=$(echo -n "$output" | md5sum | awk '{print $1}')
      yq e -i ".official.part${part} = \"$hash_output\"" "$solutions_file"
      echo "Official answer saved."
    else
      local update_path="(.examples[] | select(.input == \"$example_name.txt\"))"
      yq e -i "$update_path.part$part = \"$output\"" "$solutions_file"
      echo "Example answer saved."
    fi
  fi
}
