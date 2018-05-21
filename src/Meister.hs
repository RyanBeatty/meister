module Meister
    ( mapReduce
    ) where

import Data.Functor

mapReduce :: [a] -> (a -> b) -> [b]
mapReduce items f = f <$> items
