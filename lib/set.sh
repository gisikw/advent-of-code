_usage() {
  echo "set <year> <day> <language>"
  echo "Set default year, day, and language"
}

main() {
  # Validate Year
  if ! [[ $1 =~ ^[0-9]{4}$ ]]; then
    echo "Error: Year must be a four-digit number."
    return 1
  fi

  # Validate Day
  if ! [[ $2 =~ ^[0-9]+$ ]] || [ $2 -lt 1 ] || [ $2 -gt 25 ]; then
    echo "Error: Day must be an integer between 1 and 25."
    return 1
  fi

  # Format Day as two digits
  local formatted_day=$(printf "%02d" "$2")

  # Validate Language
  local valid_langs=$(yq eval '.languages | keys' "${local_path}/config.yml")
  if ! [[ " $valid_langs " =~ " $3 " ]]; then
    echo "Error: Language must be one of the supported languages."
    echo "$valid_langs"
    return 1
  fi

  echo "export AOC_YEAR=$1" >> $AOC_TEMPFILE
  echo "export AOC_DAY=$formatted_day" >> $AOC_TEMPFILE
  echo "export AOC_LANG=$3" >> $AOC_TEMPFILE
}
