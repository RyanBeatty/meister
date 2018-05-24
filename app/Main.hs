module Main where

import Meister

import qualified Data.Text as T (Text, words)
import           Data.Word      (Word64)

mapper :: FilePath -> T.Text -> [(T.Text, Word64)]
mapper _ text = flip (,) 1 <$> T.words text

reducer :: T.Text -> [Word64] -> Word64
reducer _ occ = sum occ

main :: IO ()
main = do
    print "Counting Words"
    mapReduce (newSpec "package.yaml" "out.txt" mapper reducer)
    return ()
