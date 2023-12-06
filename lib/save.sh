_usage() {
  echo "save [example] [part] <answer>"
  echo "Save a solution directly to the solutions file."
}

main() {
  _load_env
  solutions_file="$local_path/problems/$AOC_YEAR/$AOC_DAY/solutions.yml"
  example_name=""
  part="1"  # Default to part 1
  if [[ $# -eq 1 ]]; then
    # Only answer is provided
    answer=$1
  elif [[ $# -eq 2 ]]; then
    if [[ $1 =~ ^[0-9]+$ ]]; then
      # If first arg is all digits, it's the part number
      part=$1
      answer=$2
    else
      # Otherwise, it's the example name
      example_name=$1
      answer=$2
    fi
  else
    # All three arguments provided
    example_name=$1
    part=$2
    answer=$3
  fi

  if [[ -z "$example_name" ]]; then
    _save_official_answer "$answer"
  else
    _save_example_answer "$example_name" "$answer"
  fi
}

_save_official_answer() {
  answer_hash=$(echo -n "$1" | md5sum | awk '{print $1}')
  yq e -i ".official.part${part} = \"$answer_hash\"" "$solutions_file"
}

_save_example_answer() {
  example_name=$1
  answer=$2
  local update_path="(.examples[] | select(.input == \"$example_name.txt\")).part$part"
  yq e -i "$update_path = \"$answer\"" "$solutions_file"
}
