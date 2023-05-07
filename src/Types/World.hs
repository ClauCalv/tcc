{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DataKinds #-}

module Types.World where

import qualified Data.Dict as D

import Types.EntityTypes
import Types.Players
import Types.Zones

data World = World
    { _players           :: D.Dict Player
    , _priorityPlayer    :: D.RefOf Player
    , _turn              :: () -- TODO
    , _zones             :: () -- TODO
    }

