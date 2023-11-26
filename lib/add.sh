_usage() {
  echo "add <example> [<answer>]"
  echo "Add a new example input and optional answer"
}

main() {
  _load_env  # Load environment variables

  local example_name=$1
  local answer=$2
  local problem_dir="${local_path}/problems/${AOC_YEAR}/${AOC_DAY}"
  local solutions_file="${problem_dir}/solutions.yml"
  local example_file="${problem_dir}/${example_name}.txt"

  # Validate inputs
  if [[ -z "$example_name" ]]; then
    echo "Error: Example name is required."
    return 1
  fi

  # Check for existing example
  if [[ -f "$solutions_file" ]]; then
    local existing_example=$(yq e ".examples[] | select(.input == \"$example_name.txt\")" "$solutions_file")
    if [[ -n "$existing_example" ]]; then
      echo "Error: An example with the name '$example_name' already exists."
      return 1
    fi

    # Add new example
    yq e -i ".examples += [{\"input\": \"$example_name.txt\", \"answer\": \"$answer\"}]" "$solutions_file"
  else
    echo "Error: solutions.yml not found."
    return 1
  fi

  # Create and open the example input file
  touch "$example_file"
  ${EDITOR:-vi} "$example_file"
}
