import System.Environment
import Data.List (sortBy, foldl')
import Data.Ord (comparing)

data Transformation = Transformation { dst :: Int, src :: Int, len :: Int } deriving (Show)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [inputFile, part] -> do
      content <- readFile inputFile
      let (seeds, definitions) = parseContent content
      let results = case (read part) of
                      1 -> minimum $ map (processTransforms definitions) seeds
                      2 -> seekMinimum 1 seeds definitions
      print results
    _ -> putStrLn "Incorrect arguments"

parseContent content =
  case lines content of
    (seedLine : defLines) -> (parseSeeds seedLine, parseDefinitions defLines)
    _ -> error "Malformed input file"

parseSeeds line = map (read :: String -> Int) (drop 1 $ words line)

parseDefinitions input = drop 1 $ reverse $ map parseBlock $ splitBlocks input [] []

splitBlocks [] current defs = reverse current : defs
splitBlocks ("" : ls) current defs = splitBlocks ls [] (reverse current : defs)
splitBlocks (l : ls) current defs = splitBlocks ls (l : current) defs

parseBlock block = sortBy (comparing dst) $ map parseRange $ drop 1 block

parseRange line =
  let [dst, src, len] = map (read :: String -> Int) $ words line
  in Transformation dst src len

processTransforms definitions seed = foldl' transform seed definitions

transform :: Int -> [Transformation] -> Int
transform n [] = n
transform n (Transformation dst src len : rs)
  | n >= src && n < src + len = n + dst - src
  | otherwise = transform n rs

processUntransforms definitions seed = foldl' untransform seed $ reverse definitions

untransform n [] = n
untransform n (Transformation dst src len : rs)
  | n >= dst && n < dst + len = n + src - dst
  | n < dst = n
  | otherwise = untransform n rs

seekMinimum n seeds definitions =
  let s = processUntransforms definitions n
  in if haveSeed s seeds then n else seekMinimum (n + 1) seeds definitions

haveSeed s [] = False
haveSeed s (init:len:rest)
  | s >= init && s < init + len = True
  | otherwise = haveSeed s rest
