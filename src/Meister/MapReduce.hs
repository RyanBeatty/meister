{-# LANGUAGE OverloadedStrings #-}
module Meister.MapReduce
    ( mapReduce
    ) where

import Meister.Types (Mapper, Reducer, MeisterSpec (..))

import           Data.Functor
import qualified Data.Map.Strict as M   (empty, insertWith, toList)  
import qualified Data.Text       as T   (Text, append, pack, unlines)
import qualified Data.Text.IO    as TIO (readFile, writeFile, putStrLn)

import Data.Word

mapReduce :: MeisterSpec FilePath T.Text T.Text Word64 -> IO ()
mapReduce MeisterSpec { _datasource=datasource, _datasink=datasink, _mapper=mapper, _reducer=reducer } = do
    -- -- TODO: Assuming file is utf-8 encoded.
    -- -- TODO: Catch file not found error?
    -- input <- TIO.readFile infile
    -- let mapped    = mapper infile input
    -- let collected = M.toList $ foldr (\(c, d) hm -> M.insertWith (++) c [d] hm) M.empty mapped
    -- let reduced   = (\(k, vs) -> (k, reducer k vs)) <$> collected
    -- let output    = T.unlines . fmap (\(a, b) -> a `T.append` ": " `T.append` (T.pack . show $ b)) $ reduced
    -- TIO.writeFile outfile output
    input <- datasource
    let mapped = uncurry mapper input
    let collected = M.toList $ foldr (\(c, d) hm -> M.insertWith (++) c [d] hm) M.empty mapped
    let reduced = (\(k, vs) -> (k, reducer k vs)) <$> collected
    datasink reduced
    