_usage() {
  echo "new <year> <day> [<language>]"
  echo "Create a new solution"
}

main() {
  source "${local_path}/lib/set.sh"
  main "$@"
  _load_env
  _confirm "Create new solution in ./solutions/$AOC_YEAR/$AOC_DAY/$AOC_LANG?"
  mkdir -p "${local_path}/solutions/$AOC_YEAR/$AOC_DAY"
  cp -r "${local_path}/languages/$AOC_LANG" "${local_path}/solutions/$AOC_YEAR/$AOC_DAY/$AOC_LANG"
  _confirm "Solution created. Would you like to fetch the input?"
  source "${local_path}/lib/fetch.sh"
  main $AOC_YEAR $AOC_DAY
}
