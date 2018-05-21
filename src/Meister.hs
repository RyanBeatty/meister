module Meister
    ( mapReduce
    ) where

import           Data.Functor
import qualified Data.Map.Strict as M   (empty, insertWith, toList)  
import qualified Data.Text       as T   (Text)
import qualified Data.Text.IO    as TIO (readFile, writeFile)

type Mapper c d      = (FilePath -> T.Text -> [(c, d)])
type Reducer c d e f = (c -> [d] -> (e, f))

mapReduce :: (Ord c, Show c, Show d, Show e, Show f) => FilePath -> FilePath -> Mapper c d -> Reducer c d e f -> IO ()
mapReduce infile outfile mapper reducer = do
    -- TODO: Assuming file is utf-8 encoded.
    -- TODO: Catch file not found error?
    input <- TIO.readFile infile
    let mapped    = mapper infile input
    let collected = M.toList $ foldr (\(c, d) hm -> M.insertWith (++) c [d] hm) M.empty mapped
    let reduced   = uncurry reducer <$> collected
    print reduced
    return ()
