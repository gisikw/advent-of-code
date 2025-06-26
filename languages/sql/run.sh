#!/bin/bash
input_file=$1
part=$2

# Create a new DB each run
db=aoc.db
rm -f "$db"

sqlite3 "$db" <<EOF
CREATE TABLE config (key TEXT, value INT);
CREATE TABLE lines (line TEXT);
CREATE TABLE output (text TEXT);

INSERT INTO config (key, value) VALUES ('part', $part);
EOF

# Insert lines from input
while IFS= read -r line; do
  sqlite3 "$db" "INSERT INTO lines (line) VALUES ('$line');"
done < "$input_file"

# Run solution
sqlite3 "$db" < solution.sql

# Show result
sqlite3 "$db" "SELECT text FROM output;"
