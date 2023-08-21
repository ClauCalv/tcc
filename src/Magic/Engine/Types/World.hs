{-# LANGUAGE TemplateHaskell #-}
module Magic.Engine.Types.World where

import Magic.Engine.Types.Player
import Magic.Engine.Types.Zone
import Magic.Engine.Types.Object

import qualified Magic.Data.Dict as D
import Optics (makeLenses)

type Event = String

data Timestamp = Timestamp {
    _turn :: Integer,
    _count :: Integer
} deriving (Eq, Ord)

data MagicWorld = MagicWorld {
    _zones :: Zones,
    _players :: D.AssocDict PlayerRef Player,
    _priorityOrder :: [Player],
    
    _currTime :: Timestamp,
    _history :: D.AssocList Timestamp [Event]
}

makeLenses ''Timestamp
makeLenses ''MagicWorld

emptyWorld :: MagicWorld
emptyWorld = MagicWorld {
    _zones = emptyZones,
    _players = D.empty,
    _priorityOrder = [],
    
    _currTime = Timestamp 0 0,
    _history = []
}
