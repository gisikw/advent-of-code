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
  for (src in 1:length(row)) {
    if (row[src] == "O") {
      dest <- src
      while (row[dest-1] != "#" && row[dest-1] != "O" && dest > 1) {
        dest <- dest - 1  
      }
      if (dest != src) {
        row[src] = "."
        row[dest] = "O"
      }
    }
  }
  row
}

do_gravity <- function(grid) {
  t(apply(grid, 1, do_gravity_row))
}

score_row <- function(row) {
  sum(row=="O")
}

score <- function(grid) {
  row_scores <- apply(grid, 1, score_row)
  i <- length(row_scores)
  total <- 0
  for (score in row_scores) {
    total <- total + i * score
    i <- i - 1
  }
  total
}

cycle <- function(grid) {
  grid <- do_gravity(grid)
  grid <- rrotate(grid)
  grid <- do_gravity(grid)
  grid <- rrotate(grid)
  grid <- do_gravity(grid)
  grid <- rrotate(grid)
  grid <- do_gravity(grid)
  grid <- rrotate(grid)
  grid
}

if (part == 1) {
  grid <- rotate(grid)
  grid <- do_gravity(grid)
  grid <- rrotate(grid)
  cat(sprintf("%d\n",score(grid)))
} else {
  target_cycles <- 1000000000
  seen <- c()
  while (TRUE) {
    grid <- rrotate(cycle(rotate(grid)))
    grid_str <- paste(grid, collapse = "")
    if (grid_str %in% seen) break
    seen <- append(seen, grid_str)
  }
  offset <- match(paste(grid, collapse = ""), seen)
  loop_len <- length(seen) + 1 - offset
  remaining_cycles = (target_cycles - offset) %% loop_len
  for (i in 1:remaining_cycles) {
    grid <- rrotate(cycle(rotate(grid)))
  }
  cat(sprintf("%d\n",score(grid)))
}
