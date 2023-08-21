{-# LANGUAGE TypeFamilies #-}

module Magic.Engine.Types.Effect where

import {-# SOURCE #-} Magic.Engine.Types.World
import {-# SOURCE #-} Magic.Engine.Types.Event
import Magic.Engine.MagicGame

import Control.Algebra
import Control.Effect.State
import Optics
import Data.Class.Wrap (Wrap)


class Effect e where
    runEffect :: (Has (State MagicWorld) sig m, Has MagicGame sig m, Event ev) => e -> m ev

instance Effect e => Wrap Effect where
    runEffect (MkWrap e) = runEffect e

{-
data Effect = 
    DealDamage {
        damageSource :: Object,
        damageTarget :: Either PlayerRef (ObjectZoneRef PermanentObjTp),
        damageAmount :: Integer
    } | Destroy {
        destroySource :: Maybe Object,
        destroyTarget :: ObjectZoneRef PermanentObjTp,
        canRegenerate :: Bool
    } | DrawCards {
        targetPlayer :: PlayerRef,
        cardsToDraw :: Integer
    } | ShuffleDeck {
        targetPlayer :: PlayerRef
    } | MoveNonPermanent {
        objectToMove :: Maybe (ObjectZoneRef old),
        targetMoveZone :: ZoneRef new
    }
-}