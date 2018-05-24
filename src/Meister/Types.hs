module Meister.Types 
    ( Mapper
    , Reducer
    , MeisterSpec (..)
    , newSpec) where

type Mapper a b c d  = (a -> b -> [(c, d)])
type Reducer c d = (c -> [d] -> d)

data MeisterSpec a b c d = MeisterSpec
    { _infile  :: FilePath
    , _outfile :: FilePath
    , _mapper  :: Mapper a b c d
    , _reducer :: Reducer c d
    }

newSpec :: FilePath -> FilePath -> Mapper a b c d -> Reducer c d -> MeisterSpec a b c d
newSpec = MeisterSpec