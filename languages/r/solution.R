args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
part <- args[2]

lines <- length(readLines(input_file))
cat(sprintf("Received %d lines of input for part %s\n", lines, part))
