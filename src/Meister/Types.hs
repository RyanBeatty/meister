module Meister.Types 
    ( Mapper
    , Reducer) where

type Mapper a b c d  = (a -> b -> [(c, d)])
type Reducer c d e f = (c -> [d] -> (e, f))

data MeisterSpecification a b c d e f = MeisterSpecification
        { _infile  :: FilePath
        , _outfile :: FilePath
        , _mapper  :: Mapper a b c d
        , reducer  :: Reducer c d e f
        }