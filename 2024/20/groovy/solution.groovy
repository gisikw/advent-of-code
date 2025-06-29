def inputFile = args[0]
def part = args[1]
def grid = new File(inputFile).readLines()

def start
def end
for (row in 0..grid.size() - 1) {
  for (col in 0..grid[0].size() - 1) {
    if (grid[row][col] == "S") start = [row, col]
    if (grid[row][col] == "E") end = [row, col]
  }
}

def dist = [:]
dist[start] = 0

def queue = [start]
def visited = []

while (queue) {
  def idx = 0
  def minDist = dist[queue[0]]
  for (i in 0..queue.size() - 1) {
    if (dist[queue[i]] < minDist) {
      idx = i
      minDist = dist[queue[i]]
    }
  }

  def node = queue[idx]
  queue.remove(idx)
  visited << node

  def neighbors = [
    [node[0] - 1, node[1]],
    [node[0] + 1, node[1]],
    [node[0], node[1] - 1],
    [node[0], node[1] + 1]
  ]

  for (neighbor in (neighbors - visited)) {
    if (grid[neighbor[0]][neighbor[1]] == "#") continue
    if (dist[neighbor] == null || dist[node] + 1 < dist[neighbor]) {
      dist[neighbor] = dist[node] + 1
      queue << neighbor
    }
  }
}

def sum = 0
for (row in 0..grid.size() - 1) {
  for (col in 0..grid[0].size() - 1) {
    def node = [row, col]
    if (dist[node] == null) continue

    if (part == "1") {
      cheats = [
        [node[0] - 2, node[1]],
        [node[0] - 1, node[1] - 1],
        [node[0] - 1, node[1] + 1],

        [node[0], node[1] + 2],
        [node[0] - 1, node[1] + 1],
        [node[0] + 1, node[1] + 1],

        [node[0] + 2, node[1]],
        [node[0] + 1, node[1] - 1],
        [node[0] + 1, node[1] + 1],

        [node[0], node[1] - 2],
        [node[0] - 1, node[1] - 1],
        [node[0] + 1, node[1] - 1],
      ]
    } else {
      cheats = []
      for (y in -20..20) {
        for (x in -20..20) {
          if (Math.abs(y) + Math.abs(x) <= 20) {
            cheats << [node[0] + y, node[1] + x] 
          }
        }
      }
    }

    for (cheat in cheats) {
      if (dist[cheat] == null) continue
      def traveled = Math.abs(node[0] - cheat[0]) + Math.abs(node[1] - cheat[1])
      if (dist[cheat] - dist[node] >= 100 + traveled) sum += 1
    }
  }
}
println sum
