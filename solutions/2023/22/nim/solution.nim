import os, strutils, sequtils, sugar, parseutils, algorithm

type
  Cell = object
    x, y, z: int

type
  Brick = object
    x1, y1, z1: int
    x2, y2, z2: int
    state: int

proc makeBrick(a: seq[int]): ref Brick =
  var brick = new Brick
  brick[] = Brick(x1:a[0],y1:a[1],z1:a[2],x2:a[3],y2:a[4],z2:a[5],state:0)
  return brick

proc cells(b: ref Brick): iterator (): Cell =
  if b.x1 != b.x2:
    iterator (): Cell =
      var x = b.x1
      while x <= b.x2:
        yield Cell(x: x, y: b.y1, z: b.z1)
        inc x
  elif b.y1 != b.y2:
    iterator (): Cell =
      var y = b.y1
      while y <= b.y2:
        yield Cell(x: b.x1, y: y, z: b.z1)
        inc y
  else:
    iterator (): Cell =
      var z = b.z1
      while z <= b.z2:
        yield Cell(x: b.x1, y: b.y1, z: z)
        inc z

proc cmpLeastZ(a, b: ref Brick): int =
  cmp(min(a.z1,a.z2),min(b.z1,b.z2))

proc worldOfBricks(bricksArg: seq[ref Brick]): seq[seq[seq[ref Brick]]] =
  var bricks = bricksArg.filter(b => b != nil)
  var minY = 1000
  var maxY = 0
  var minX = 1000
  var maxX = 0
  var minZ = 1000
  var maxZ = 0
  for brick in bricks:
    minX = min(minX, min(brick.x1, brick.x2))
    maxX = max(maxX, max(brick.x1, brick.x2))
    minY = min(minY, min(brick.y1, brick.y2))
    maxY = max(maxY, max(brick.y1, brick.y2))
    minZ = min(minZ, min(brick.z1, brick.z2))
    maxZ = max(maxZ, max(brick.z1, brick.z2))
  var world = newSeqWith(maxZ+1, newSeqWith(maxX+1, newSeq[ref Brick](maxY+1)))
  for brick in bricks:
    for cell in brick.cells:
      world[cell.z][cell.x][cell.y] = brick
  # Gravity
  for brick in bricks:
    var z = brick.z1 - 1
    block scan:
      while z > 0:
        for cell in brick.cells:
          if world[z][cell.x][cell.y] != nil:
            break scan
        z -= 1
    z += 1
    if z > 0 and z != brick.z1:
      let shift = brick.z1 - z
      for cell in brick.cells:
        world[cell.z][cell.x][cell.y] = nil
      brick.z1 -= shift
      brick.z2 -= shift
      for cell in brick.cells:
        world[cell.z][cell.x][cell.y] = brick
  return world

proc upNeighbors(brick: ref Brick, world: seq[seq[seq[ref Brick]]]): seq[ref Brick] =
  toSeq(brick.cells)
    .map(c => world[c.z+1][c.x][c.y])
    .filter(b => b != nil and b != brick)
    .deduplicate()

proc downNeighbors(brick: ref Brick, world: seq[seq[seq[ref Brick]]]): seq[ref Brick] =
  toSeq(brick.cells)
    .map(c => world[c.z-1][c.x][c.y])
    .filter(b => b != nil and b != brick)
    .deduplicate()

let
  inputFile = paramStr(1)
  part = paramStr(2)

var lines = readFile(inputFile).splitLines
if lines.len > 0 and lines[lines.len - 1] == "":
  lines.setLen(lines.len - 1)
  
var bricks = lines.map(l => l.split({'~',','}).map(parseInt)).map(makeBrick)
bricks.sort(cmpLeastZ)
var world = worldOfBricks(bricks)

if part == "1":
  var result = 0
  for brick in bricks:
    block scan:
      if all(upNeighbors(brick, world), n => downNeighbors(n, world).len > 1):
        result += 1
  echo result
else:
  var sum = 0
  var omit = 0
  var oldBricks = bricks.map(b => b[])
  while omit < oldBricks.len:
    let omittedRef = bricks[omit]
    bricks[omit] = nil
    discard worldOfBricks(bricks)
    for i in oldBricks.low..oldBricks.high:
      if bricks[i] == nil:
        bricks[i] = omittedRef
      elif bricks[i][] != oldBricks[i]:
        bricks[i][] = oldBricks[i]
        sum += 1
    omit += 1
  echo sum
