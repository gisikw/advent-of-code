args := System args

inputFile := args at(1)
part := args at(2)

maxDepth := if(part == "1", 2, 25)

content := File with(inputFile) contents
lines := content split("\n")

numpad := Map with(
  "7", list(0, 0),
  "8", list(0, 1),
  "9", list(0, 2),
  "4", list(1, 0),
  "5", list(1, 1),
  "6", list(1, 2),
  "1", list(2, 0),
  "2", list(2, 1),
  "3", list(2, 2),
  "0", list(3, 1),
  "A", list(3, 2)
)

dirpad := Map with(
  "^", list(0, 1),
  "A", list(0, 2),
  "<", list(1, 0),
  "v", list(1, 1),
  ">", list(1, 2)
)

numpaths := Map clone
numpad foreach (src, srcCoords,
  srcPaths := Map clone
  numpad foreach (dest, destCoords,
    rowDist := destCoords at(0) - srcCoords at(0)
    colDist := destCoords at(1) - srcCoords at(1)

    rowStr := if(rowDist > 0, "v" repeated(rowDist abs), "^" repeated(rowDist abs))
    colStr := if(colDist > 0, ">" repeated(colDist abs), "<" repeated(colDist abs))

    paths := list()
    if(srcCoords at(1) != 0 or destCoords at(0) != 3,
      paths append("#{rowStr}#{colStr}" interpolate asList)
    )
    if(srcCoords at(0) != 3 or destCoords at(1) != 0,
      paths appendIfAbsent("#{colStr}#{rowStr}" interpolate asList)
    )

    srcPaths atPut(dest, paths)
  )
  numpaths atPut(src, srcPaths)
)

dirpaths := Map clone
dirpad foreach (src, srcCoords,
  srcPaths := Map clone
  dirpad foreach (dest, destCoords,
    rowDist := destCoords at(0) - srcCoords at(0)
    colDist := destCoords at(1) - srcCoords at(1)

    rowStr := if(rowDist > 0, "v" repeated(rowDist abs), "^" repeated(rowDist abs))
    colStr := if(colDist > 0, ">" repeated(colDist abs), "<" repeated(colDist abs))

    paths := list()
    if(src != "<",
      paths append("#{rowStr}#{colStr}" interpolate asList)
    )
    if(dest != "<",
      paths appendIfAbsent("#{colStr}#{rowStr}" interpolate asList)
    )

    srcPaths atPut(dest, paths)
  )
  dirpaths atPut(src, srcPaths)
)

Node := Object clone

cache := list()
for(i, 0, 26, cache append(Map clone))
cost := method(node,

  // Init case
  if (node protos contains(Node) == false,
    sum := 0
    node asList foreach(i, char, 
      child := Node clone
      child src := if(i == 0, "A", node asList at(i - 1))
      child dst := char
      child depth := 0
      sum = sum + cost(child)
    )
    return sum
  )
  
  if (node depth == 0,
    options := numpaths at(node src) at(node dst)
    min := nil
    options foreach(opt,
      sum := 0
      opt foreach(i, char,
        child := Node clone
        child src := if(i == 0, "A", opt at(i - 1))
        child dst := char
        child depth := node depth + 1
        sum = sum + cost(child)
      )
      child := Node clone
      child src := opt last
      child dst := "A"
      child depth := node depth + 1
      sum = sum + cost(child)
      if(min == nil or sum < min, min = sum)
    )
    return min
  )

  if (node depth > maxDepth, return 1)

  cached := cache at(node depth) at("#{node src}#{node dst}" interpolate)
  if (cached != nil, return cached)

  options := dirpaths at(node src) at(node dst)
  min := nil
  if (options size == 0, return 1)
  options foreach(opt,
    sum := 0
    opt foreach(i, char,
      child := Node clone
      child src := if(i == 0, "A", opt at(i - 1))
      child dst := char
      child depth := node depth + 1
      sum = sum + cost(child)
    )
    if (opt size == 0,
      sum = sum + 1,
      child := Node clone
      child src := opt last
      child dst := "A"
      child depth := node depth + 1
      sum = sum + cost(child)
    )
    if(min == nil or sum < min, min = sum)
  )

  cache at(node depth) atPut("#{node src}#{node dst}" interpolate, min)
  return min
)

complexity := method(code,
  num := code asMutable removeSeq("A", "") asNumber
  num * cost(code)
)

digits := method(num,
  i := 0
  while(num > 1,
    num = num / 10
    i = i + 1
  )
  i
)

sum := 0
lines foreach(line, sum = sum + complexity(line))
sum asString(digits(sum),0) println
0
