{-# LANGUAGE DuplicateRecordFields, TypeFamilies #-}
module Magic.Engine.Types.Effect.GainManaEffect where

import Magic.Engine.Types.Effect
import Magic.Engine.Types.Ability
import Magic.Engine.Types.Zone
import Magic.Engine.Types.Object
import Magic.Engine.Types.World
import Magic.Engine.Types.Player

import Magic.Engine.Types.Mana

import Control.Effect.Optics
import Optics hiding (modifying, modifying', assign, assign', use, preuse) -- Hide Optics.State entirely!

import Data.Class.Wrap (Wrap(MkWrap))
import Data.Maybe (fromJust)

data GainManaEffect = GainManaEffect {
        targetPlayer :: PlayerRef,
        manaGainAmount :: ManaPool
    }

instance Effect GainManaEffect where
    data EventHistory GainManaEffect = ManaGained {
        targetPlayer :: PlayerRef,
        manaGainAmount :: ManaPool
    }
    runEffect (GainManaEffect p m) = do
        modifying (players % ix p % manaPool) (<> m)
        return $ ManaGained p m

gainManaSelf :: ManaPool -> EffectActivation
gainManaSelf m actCtx = return [MkWrap $ GainManaEffect (fromJust $ actCtx ^. activator) m]