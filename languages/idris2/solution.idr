module Main

import System
import System.File
import Data.String

main : IO ()
main = do
    args <- getArgs
    case args of
        [_, inputFile, part] => do
            Right content <- readFile inputFile
                | Left err => putStrLn "Error reading file"
            let lines = lines content
            let linesCount = length lines
            putStrLn $ "Received " ++ show linesCount ++ " lines of input for part " ++ part
        _ => putStrLn "Usage: solution <input_file> <part>"
