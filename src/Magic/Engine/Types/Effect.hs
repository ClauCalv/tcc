module Magic.Engine.Types.Effect where

import Control.Carrier.State.Church (State, modify)
import Control.Monad (when)
import Data.Maybe (isJust)
import Types.World (World(_zones))
import qualified Data.Dict as D
import Control.Effect.Optics (assign)
import Optics (At(at))

class Effect e where
    data EventHistory e
    runEffect :: (Has (State MagicWorld) sig m, Has MagicGame sig m) => e -> m (EventHistory e)


data Effect = 
    GainMana {
        targetPlayer :: PlayerRef,
        manaGainAmount :: ManaTotal
    } | DealDamage {
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