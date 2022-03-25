{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}

module Types.MagicGameTypes where

import qualified Data.Dict as D
import Types.World
import Types.Player
import Effects.Server

data GameState = GameState
    { _world    :: World
    , _gameMode :: GameMode
    , _history  :: EventList
    , _playerMapping :: [(D.RefOf Player, ServerPlayerRef)]
    }

data GameMode = Standart -- TODO in future: | Commander | Legacy
    deriving (Eq, Show, Read)

type EventList = () -- TODO