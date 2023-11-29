import System.Environment

main :: IO ()
main = do
    args <- getArgs
    let inputFile = args !! 0
    let part = args !! 1

    content <- readFile inputFile
    let linesCount = length (lines content)

    putStrLn $ "Received " ++ show linesCount ++ " lines of input for part " ++ part
