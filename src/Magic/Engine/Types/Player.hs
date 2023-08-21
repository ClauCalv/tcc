{-# LANGUAGE TemplateHaskell #-}
module Magic.Engine.Types.Player where

import Optics (makeLenses)
import Magic.Engine.Types.Mana (ManaPool)
import qualified Data.EnumMultiSet as EMS

type PlayerRef = Int

data Player = MkPlayer {
    _life :: Integer,
    _manaPool :: ManaPool
    -- counter :: EnumMultiSet Counter
}

makeLenses ''Player

emptyPlayer :: Player
emptyPlayer = MkPlayer 20 EMS.empty