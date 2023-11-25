_usage() {
  echo "fetch <year> <day>"
  echo "Fetch the input.txt for a specific year and day from Advent of Code"
}

main() {
  _require_session  # Ensure session cookie is available

  local year=$1
  local day=${2#0}  # Remove leading zero if present
  local formatted_day=$(printf "%02d" "$day")  # Ensure two-digit format for local directory
  local url="https://adventofcode.com/${year}/day/${day}/input"
  local problem_dir="${local_path}/problems/${year}/${formatted_day}"

  # Validate Year and Day
  if ! [[ $year =~ ^[0-9]{4}$ ]]; then
    echo "Error: Year must be a four-digit number."
    return 1
  fi

  if ! [[ $day =~ ^[0-9]+$ ]] || [ $day -lt 1 ] || [ $day -gt 25 ]; then
    echo "Error: Day must be an integer between 1 and 25."
    return 1
  fi

  # Fetch the file with the session cookie
  if curl --fail --silent --output /dev/null --head -b "session=${AOC_SESSION}" "$url"; then
    mkdir -p "$problem_dir"
    curl -s -b "session=${AOC_SESSION}" "$url" -o "${problem_dir}/input.txt"
  else
    echo "Error: Could not fetch input. Check if the input is available for Year ${year}, Day ${day}."
    return 1
  fi
}
