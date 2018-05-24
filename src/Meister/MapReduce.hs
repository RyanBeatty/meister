{-# LANGUAGE OverloadedStrings #-}
module Meister.MapReduce
    ( mapReduce
    ) where

import Meister.Types (Mapper, Reducer, MeisterSpec (..))

import           Data.Functor
import qualified Data.Map.Strict as M   (empty, insertWith, toList)  
import qualified Data.Text       as T   (Text, append, pack, unlines)
import qualified Data.Text.IO    as TIO (readFile, writeFile, putStrLn)

mapReduce :: Ord c => MeisterSpec a b c d -> IO ()
mapReduce MeisterSpec { _datasource=datasource, _datasink=datasink, _mapper=mapper, _reducer=reducer } = do
    input <- datasource
    let mapped = uncurry mapper input
    let collected = M.toList $ foldr (\(c, d) hm -> M.insertWith (++) c [d] hm) M.empty mapped
    let reduced = (\(k, vs) -> (k, reducer k vs)) <$> collected
    datasink reduced
    