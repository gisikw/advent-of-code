_usage() {
  echo "set <year> <day> <language>"
  echo "Set default year, day, and language"
}

main() {
  _confirm "Set year to $1, day to $2, and language to $3?"
  echo "export AOC_YEAR=$1" >> $AOC_TEMPFILE
  echo "export AOC_DAY=$2" >> $AOC_TEMPFILE
  echo "export AOC_LANG=$3" >> $AOC_TEMPFILE
}
