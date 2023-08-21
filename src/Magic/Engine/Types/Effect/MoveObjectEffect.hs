{-# LANGUAGE DuplicateRecordFields, TypeFamilies #-}
module Magic.Engine.Types.Effect.MoveObjectEffect where

import Magic.Engine.Types.Effect
import Magic.Engine.Types.Ability
import Magic.Engine.Types.World
import Magic.Engine.Types.Zone

import Magic.Engine.Types.Object

import Control.Effect.Optics
import Optics hiding (modifying, modifying', assign, assign', use, preuse) -- Hide Optics.State entirely!

import qualified Magic.Data.Dict as D
import Data.Maybe (fromJust)

data MoveObjectEffect old new = MoveObjectEffect {
    oldObjRef :: Maybe (ObjectZoneRef old),
    newZone :: ZoneRef new, 
    newObj :: ObjectOfType new
}

instance Effect (MoveObjectEffect old new) where
    data EventHistory (MoveObjectEffect old new) = ObjectDidMove {
        oldObjRef :: Maybe (ObjectZoneRef old),
        newObjRef :: ObjectZoneRef new
    }
    runEffect (MoveObjectEffect oldRef newZoneRef newObj) = do
        case oldRef of
            Just (MkObjectZoneRef oldZoneRef oldObjRef) -> do
                --Remove object from where it was
                oldZone <- preuse $ zones % atZone oldZoneRef % objects
                let (_, oldZone') = D.remove oldObjRef (fromJust oldZone)
                assign (zones % atZone oldZoneRef % objects) oldZone'
            Nothing -> return ()
        -- insert new object into new zone
        newZone <- preuse $ zones % atZone newZoneRef % objects
        let (newObjRef, newZone') = D.put newObj (fromJust newZone)
        assign (zones % atZone newZoneRef % objects) newZone'
        return $ ObjectDidMove oldRef (MkObjectZoneRef newZoneRef newObjRef)