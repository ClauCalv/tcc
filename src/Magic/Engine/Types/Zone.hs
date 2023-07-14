module Magic.Engine.Types.Zone where

import Magic.Engine.Types.Object
import qualified Data.Dict as D
import Optics.Indexed (IxLens')
import Optics (makeLenses)

data Zones = Zones {
    _library :: D.AssocDict PlayerRef (Zone CardObject) ,
    _hand :: D.AssocDict (Zone CardObject) ,
    _graveyard :: D.AssocDict (Zone CardObject) ,
    _exile :: Zone CardObject,
    _battlefield :: Zone PermanentObject,
    _stack :: Zone StackObject
}

data Zone (a :: ObjectType) = Zone {
    _zoneOwner :: Maybe PlayerRef,
    _objects :: D.AssocDict ObjectRef a
}

makeLenses ''Zone
makeLenses ''Zones

emptyZones :: Zones
emptyZones = Zones {
    library = D.empty,
    hand = D.empty,
    graveyard = D.empty,
    exile = Zone Nothing D.empty,
    battlefield = Zone Nothing D.empty,
    stack = Zone Nothing D.empty
}

type ObjectRef = Int
data ZoneRef (a :: ObjectType) where
  Library     :: PlayerRef -> ZoneRef CardObjTp
  Hand        :: PlayerRef -> ZoneRef CardObjTp
  Graveyard   :: PlayerRef -> ZoneRef CardObjTp
  Exile       ::              ZoneRef CardObjTp
  Battlefield ::              ZoneRef PermanentObjTp
  Stack       ::              ZoneRef StackItemObjTp

data ObjectZoneRef a = ObjectZoneRef {
    zoneRef :: ZoneRef a,
    objRef :: ObjectRef
}

makeLenses ''ObjectZoneRef

type instance Index Zones = ZoneRef
type instance IxValue Zones = Zone 
instance Ixed Zones where
    type IxKind Zones = An_AffineTraversal
    ix :: ZoneRef -> AffineTraversal' Zones Zone
    ix zoneref = atraversal (\zs -> maybeToEither zs (solveZoneRef zoneref)) (\zs z -> modifyZoneRef zoneref (const z) zs)


solveZoneRef :: ZoneRef a -> Zones -> Maybe (Zone a)
solveZoneRef (Library p)   = find p . library
solveZoneRef (Hand p)      = find p . hand
solveZoneRef (Graveyard p) = find p . graveyard
solveZoneRef Exile         = exile
solveZoneRef Battlefield   = battlefield
solveZoneRef Stack         = stack

modifyZoneRef :: ZoneRef a -> (Zone a -> Zone a) -> Zones -> Zones
modifyZoneRef ref f zs = let z = solveZoneRef ref in case ref of 
    (Library p)   -> zs {library = D.modify f p z }
    (Hand p)      -> zs {hand = D.modify f p z }
    (Graveyard p) -> zs {graveyard = D.modify f p z }
    Exile         -> zs {exile = f z }
    Battlefield   -> zs {battlefield = f z }
    Stack         -> zs {stack = f z }