_usage() {
  echo "unused [year]"
  echo "Show unused languages that have configured templates"
}

main() {
  comm -23 \
    <(yq '.languages | keys' config.yml | sed 's/- //' | sort) \
    <(find ./solutions/$1/* -type d -exec basename {} \; | sort | uniq)
}
