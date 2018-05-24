{-# LANGUAGE OverloadedStrings #-}
module Meister.MeisterTest where

import Meister

import Data.Text             as T
import Data.Text.IO          as TIO
import Data.Word
import Test.Tasty.Hspec      as HS
import Test.Tasty.HUnit      as HU
import Test.Tasty.Providers

mapper :: FilePath -> T.Text -> [(T.Text, Word64)]
mapper _ text = flip (,) 1 <$> T.words text

reducer :: T.Text -> [Word64] -> Word64
reducer _ occ = sum occ

test_mapReduce :: TestTree
test_mapReduce =
    testCase "mapReduce" $ do
        mapReduce (newSpec "input.txt" "output.txt" mapper reducer)
        output <- TIO.readFile "output.txt"
        assertEqual "mapReduce" output "goodbye: 2\nhello: 1\n"


