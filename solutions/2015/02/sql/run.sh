#!/bin/bash

input_file=$1
part=$2

export POSTGRES_HOST_AUTH_METHOD=trust
/usr/local/bin/docker-entrypoint.sh postgres >/dev/null 2>&1 &

# Initialize a counter for the timeout
counter=0
timeout=60  # 60 seconds

# Wait for PostgreSQL to start, with a timeout
until pg_isready -U postgres; do
  echo "Waiting for PostgreSQL to start..."
  sleep 1
  counter=$((counter+1))

  # Check if the timeout has been reached
  if [ "$counter" -ge "$timeout" ]; then
    echo "Timeout waiting for PostgreSQL to start."
    exit 1
  fi
done

# Create the database and tables
psql -U postgres -c "CREATE DATABASE aoc;"
psql -U postgres -d aoc -c "CREATE TABLE IF NOT EXISTS config (key TEXT, value INT);"
psql -U postgres -d aoc -c "CREATE TABLE IF NOT EXISTS lines (line TEXT);"
psql -U postgres -d aoc -c "CREATE TABLE IF NOT EXISTS output (text TEXT);"

# Insert the part value into the 'config' table
psql -U postgres -d aoc -c "INSERT INTO config (key, value) VALUES ('part', $part);"

# Insert the input file into the 'lines' table
while IFS= read -r line
do
  psql -U postgres -d aoc -c "INSERT INTO lines (line) VALUES ('$line');"
done < "$input_file"

# Execute the SQL solution
psql -U postgres -d aoc -f solution.sql -t | grep -v "^$" | awk '{$1=$1};1'
