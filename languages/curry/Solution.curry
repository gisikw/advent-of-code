import System.Environment (getArgs)
main :: IO ()
main = do
  [f, p] <- getArgs
  s <- readFile f
  putStrLn ("Received " ++ show (length (lines s)) ++ " lines of input for part " ++ p)
