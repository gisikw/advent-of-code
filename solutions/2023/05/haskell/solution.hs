import System.Environment

main :: IO ()
main = do
  args <- getArgs
  let inputFile = args !! 0
  let part = read (args !! 1)

  content <- readFile inputFile
  let input = lines content
  let seeds = parseSeeds (head input)
  let remainder = drop 2 input
  let definitions = parseDefinitions(input)

  let results = if part == 1 then map (processTransforms definitions) seeds else [seekMinimum seeds definitions maxBound :: Int]
  print (minimum results)

parseSeeds line = map (read :: String -> Int) (drop 1 (words line))

parseDefinitions input = drop 1 (reverse(map parseBlock (splitBlocks input [] [])))

splitBlocks [] current defs = (current:defs)
splitBlocks ("":ls) current defs = splitBlocks ls [] (current:defs)
splitBlocks (l:ls) current defs = splitBlocks ls (current ++ [l]) defs

parseBlock block = map parseRange (drop 1 block)

parseRange line = map (read :: String -> Int) (words line)

transform n [] = n
transform n (r:rs)
  | delta >= 0 && delta < len = dst + delta
  | otherwise = transform n rs
  where 
    dst = r !! 0
    delta = n - (r !! 1)
    len = r !! 2

processTransforms definitions seed = foldl transform seed definitions

seekMinimum [] defs min = min
seekMinimum (a:1:rest) defs min = seekMinimum rest defs min
seekMinimum (a:b:rest) defs min = seekMinimum (succ(a):pred(b):rest) defs (minimum [min, (processTransforms defs a)])

stringSplit [] _ =  [""]
stringSplit (c:cs) delim
  | c == delim = "" : rest
  | otherwise = (c : head rest) : drop 1 rest
  where
    rest = stringSplit cs delim
