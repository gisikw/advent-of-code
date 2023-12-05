import System.Environment

main :: IO ()
main = do
  args <- getArgs
  let (inputFile:part:_) = args
  content <- readFile inputFile
  let (seeds, definitions) = parseContent content
  let results = case (read part) of
                  1 -> minimum $ map (processTransforms definitions) seeds 
                  2 -> seekMinimum seeds definitions maxBound :: Int
  print results

parseContent content =
  let input = lines content
  in (parseSeeds $ head input, parseDefinitions input)

parseSeeds line = map (read :: String -> Int) (drop 1 $ words line)

parseDefinitions input = drop 1 $ reverse $ map parseBlock $ splitBlocks input [] []

splitBlocks [] current defs = (current:defs)
splitBlocks ("":ls) current defs = splitBlocks ls [] (current:defs)
splitBlocks (l:ls) current defs = splitBlocks ls (current ++ [l]) defs

parseBlock block = map parseRange $ drop 1 block

parseRange line = map (read :: String -> Int) $ words line

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
