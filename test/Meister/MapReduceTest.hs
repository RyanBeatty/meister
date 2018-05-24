{-# LANGUAGE OverloadedStrings #-}
module Meister.MapReduceTest where

import Meister

import Data.Text             as T
import Data.Text.IO          as TIO
import Data.Word
import Test.Tasty.Hspec      as HS
import Test.Tasty.HUnit      as HU
import Test.Tasty.Providers

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

test_mapReduce :: TestTree
test_mapReduce =
    testCase "mapReduce" $ do
        mapReduce (newSpec (inputter "input.txt") (outputter "output.txt") mapper reducer)
        output <- TIO.readFile "output.txt"
        assertEqual "mapReduce" output "goodbye: 2\nhello: 1\n"


