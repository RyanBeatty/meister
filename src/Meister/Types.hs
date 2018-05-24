module Meister.Types 
    ( Inputter
    , Mapper
    , Reducer
    , Outputter
    , MeisterSpec (..)
    , newSpec) where

type Inputter a b = IO (a, b)
type Mapper a b c d  = (a -> b -> [(c, d)])
type Reducer c d = (c -> [d] -> d)
type Outputter c d = [(c, d)] -> IO ()

data MeisterSpec a b c d = MeisterSpec
    { _datasource :: Inputter a b
    , _datasink   :: Outputter c d
    , _mapper     :: Mapper a b c d
    , _reducer    :: Reducer c d
    }

newSpec :: Ord c => Inputter a b -> Outputter c d -> Mapper a b c d -> Reducer c d -> MeisterSpec a b c d
newSpec = MeisterSpec

