input_file=$1
part=$2

lines_count=$(cat $input_file | wc -l)

echo "Received $lines_count lines of input for part $part"
