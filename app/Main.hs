module Main where

import Meister

main :: IO ()
main = do
    print $ "result: " ++ (show $ mapReduce [1, 2, 3, 4] (+1))
