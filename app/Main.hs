{-# LANGUAGE OverloadedStrings #-}
module Main where

import Meister

import qualified Data.Text    as T   (Text, words, append, unlines, pack)
import qualified Data.Text.IO as TIO (readFile, writeFile)
import           Data.Word           (Word64)

inputter :: FilePath -> IO (FilePath, T.Text)
inputter infile = (,) infile <$> TIO.readFile infile

mapper :: FilePath -> T.Text -> [(T.Text, Word64)]
mapper _ text = flip (,) 1 <$> T.words text

reducer :: T.Text -> [Word64] -> Word64
reducer _ occ = sum occ

outputter :: FilePath -> [(T.Text, Word64)] -> IO ()
outputter outfile results = do
    let output = T.unlines . fmap (\(a, b) -> a `T.append` ": " `T.append` (T.pack . show $ b)) $ results
    TIO.writeFile outfile output


main :: IO ()
main = do
    print "Counting Words"
    mapReduce (newSpec (inputter "package.yaml") (outputter "out.txt") mapper reducer)
    return ()
