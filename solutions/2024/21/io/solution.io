args := System args

inputFile := args at(1)
part := args at(2)

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

parseNumpad := method(tokens, lastToken, results,
  if(tokens size == 0, return results)
  if(lastToken == nil, 
    lastToken = "A"
    results = list("")
  )
  token := tokens at(0)
  paths := numpaths at(lastToken) at(token)

  nextResults := list()
  numpaths at(lastToken) at(token) foreach(path,
    results foreach(result, 
      pathStr := path join("")
      nextResults append("#{result}#{pathStr}A" interpolate)
    )
  )
  parseNumpad(tokens slice(1), token, nextResults)
)

parseDirpad := method(tokens, lastToken, results,
  if(tokens size == 0, return results)
  if(lastToken == nil, 
    lastToken = "A"
    results = list("")
  )
  token := tokens at(0)
  paths := dirpaths at(lastToken) at(token)

  nextResults := list()
  paths := dirpaths at(lastToken) at(token)
  if (paths isEmpty,
    results foreach(result, 
      nextResults append("#{result}A" interpolate)
    ),
    paths foreach(path, 
      results foreach(result, 
        pathStr := path join("")
        nextResults append("#{result}#{pathStr}A" interpolate)
      )
    )
  )
  parseDirpad(tokens slice(1), token, nextResults)
)

seqLength := method(code, remove, 
  seq := parseNumpad(code asList)
  for(i, 0, remove - 1, 
    seq = seq map(path, parseDirpad(path asList)) flatten
  )
  seq map(size) min
)

complexity := method(code,
  num := code asMutable removeSeq("A", "") asNumber
  if(part == "1", depth := 2, depth := 25)
  num * seqLength(code, depth)
)

sum := 0
lines foreach(line, sum = sum + complexity(line))
sum println
0
