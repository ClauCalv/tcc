module Magic.Engine.Effect.MoveObjectEffect where

import Magic.Engine.Types.Zone
import Magic.Engine.Types.Object
import Control.Carrier.State.Church (State, modify)
import Control.Monad (when)
import Data.Maybe (isJust)
import Types.World (World(_zones))
import qualified Data.Dict as D
import Control.Effect.Optics (assign)
import Optics (At(at))

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
                oldZone <- use zones % ix oldZoneRef
                let (_, oldZone') = D.remove oldObjRef
                assign (zones % ix oldZoneRef) oldZone'
            Nothing -> return ()
        -- insert new object into new zone
        newZone <- use zones % ix newZoneRef
        let (newObjRef, newZone') = D.put newObj newZone
        assign (zones % ix newZoneRef) newObjRef
        return $ ObjectDidMove oldRef (MkObjectZoneRef newZoneRef newObjRef)