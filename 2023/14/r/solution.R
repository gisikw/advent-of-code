args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
part <- args[2]

grid <- do.call(rbind, lapply(strsplit(scan(input_file, 
                 what=""), ""), as.character))

rotate <- function(grid) {
  apply(t(grid), 2, rev)
}

rrotate <- function(grid) {
  t(apply(grid, 2, rev))
}

do_gravity_row <- function(row) {
  dest <- 1  # Initialize the destination pointer
  for (src in 1:length(row)) {
    if (row[src] == "O") {
      if (src != dest) {
        row[dest] <- "O"
        row[src] <- "."
      }
      dest <- dest + 1
    } else if (row[src] == "#") {
      dest <- src + 1
    }
  }
  row
}

do_gravity <- function(grid) {
  t(apply(grid, 1, do_gravity_row))
}

score <- function(grid) {
  row_scores <- apply(grid, 1, function(row) sum(row == "O"))
  sum(row_scores * seq(from = length(row_scores), to = 1))
}

transform_and_rotate <- function(grid, n) {
  rrotate(do_gravity(grid))
}

cycle <- function(grid, unused = NULL) {
  rrotate(Reduce(transform_and_rotate, 1:4, rotate(grid), accumulate = FALSE))
}

if (part == 1) {
  cat(sprintf("%d\n",score(rrotate(do_gravity(rotate(grid))))))
} else {
  target_cycles <- 1000000000
  seen <- c()
  grid_str <- ""
  while (TRUE) {
    grid <- cycle(grid)
    grid_str <- paste(grid, collapse = "")
    if (grid_str %in% seen) break
    seen <- append(seen, grid_str)
  }
  offset <- match(grid_str, seen)
  loop_len <- length(seen) + 1 - offset
  remaining_cycles = (target_cycles - offset) %% loop_len
  grid <- Reduce(cycle, 1:remaining_cycles, grid, accumulate = FALSE)
  cat(sprintf("%d\n",score(grid)))
}
