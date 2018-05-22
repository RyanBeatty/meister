{-# LANGUAGE OverloadedStrings #-}
module Meister.MapReduce
    ( mapReduce
    ) where

import           Data.Functor
import qualified Data.Map.Strict as M   (empty, insertWith, toList)  
import qualified Data.Text       as T   (Text, append, pack, unlines)
import qualified Data.Text.IO    as TIO (readFile, writeFile, putStrLn)

import Data.Word

type Mapper c d      = (FilePath -> T.Text -> [(c, d)])
type Reducer c d e f = (c -> [d] -> (e, f))

mapReduce :: FilePath -> FilePath -> Mapper T.Text Word64 -> Reducer T.Text Word64 T.Text Word64 -> IO ()
mapReduce infile outfile mapper reducer = do
    -- TODO: Assuming file is utf-8 encoded.
    -- TODO: Catch file not found error?
    input <- TIO.readFile infile
    let mapped    = mapper infile input
    let collected = M.toList $ foldr (\(c, d) hm -> M.insertWith (++) c [d] hm) M.empty mapped
    let reduced   = uncurry reducer <$> collected
    let output    = T.unlines . fmap (\(a, b) -> a `T.append` ": " `T.append` (T.pack . show $ b)) $ reduced
    TIO.writeFile outfile output
