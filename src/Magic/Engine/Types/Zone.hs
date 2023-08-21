{-# LANGUAGE TemplateHaskell, DataKinds, TypeFamilyDependencies #-}

module Magic.Engine.Types.Zone where


import Optics
import Optics.Indexed

import Magic.Engine.Types.Object
import Magic.Engine.Types.Player

import Utils.MaybeEither (maybeToEither)
import Data.Maybe (fromJust)

import qualified Magic.Data.IndexedSet as IS
import qualified Magic.Data.AutoIndexedSet as AIS
import qualified Magic.Data.IndexedDeque as ID

import Magic.Data.Empty
import Data.Data (Proxy(Proxy))

type ObjectRef = Int

data Zones = MkZones {
    _library :: IS.IndexedSet PlayerRef (ZoneOf ZtDeque CardObjTp) ,
    _hand :: IS.IndexedSet PlayerRef (ZoneOf ZtSet CardObjTp) ,
    _graveyard :: IS.IndexedSet PlayerRef (ZoneOf ZtSet CardObjTp) ,
    _exile :: ZoneOf ZtSet CardObjTp,
    _battlefield :: ZoneOf ZtSet PermanentObjTp,
    _stack :: ZoneOf ZtDeque StackItemObjTp
}

data {-- kind --} ZoneType = ZtDeque | ZtSet
type family ZoneOf (zt :: ZoneType) = x | x -> zt where
    ZoneOf ZtDeque = DequeZone
    ZoneOf ZtSet = SetZone

class Zone z where
    type TypeOfObjects z :: ObjectType
    ixObj :: ObjectRef -> AffineTraversal' z (ObjectOfType (TypeOfObjects z))

newtype DequeZone (ot :: ObjectType) = MkDequeZone {_dzData :: ID.IndexedDeque ObjectRef (ObjectOfType ot) }
newtype SetZone (ot :: ObjectType) = MkSetZone {_szData :: AIS.AutoIndexedSet ObjectRef (ObjectOfType ot) }

makeLenses ''Zones
makeLenses ''DequeZone
makeLenses ''SetZone

instance Empty Zones where empty = MkZones empty empty empty empty empty empty    
instance Empty (DequeZone ot) where empty = MkDequeZone empty
instance Empty (SetZone ot) where empty = MkSetZone empty

instance Zone (DequeZone (ot :: ObjectType)) where
    type TypeOfObjects (DequeZone ot) = ot
    ixObj objRef = dzData % ix objRef

instance Zone (SetZone (ot :: ObjectType)) where
    type TypeOfObjects (SetZone ot) = ot
    ixObj objRef = szData % ix objRef


initializeZones :: [PlayerRef] -> Zones
initializeZones ps = MkZones (zipEmptyD ps) (zipEmptyS ps) (zipEmptyS ps) empty empty empty
    where
        zipEmptyS = IS.fromList . map (,empty)
        zipEmptyD = IS.fromList . map (,empty)

class ZoneRef a where
    type TypeOfZoneObjects a :: ObjectType
    type TypeOfZone a :: ZoneType
    ixZone :: a -> AffineTraversal' Zones (ZoneOf (TypeOfZone a) (TypeOfZoneObjects a))
    ixZoneObj :: ObjectZoneRef a -> AffineTraversal' Zones (ObjectOfType (TypeOfZoneObjects a))

type ObjectZoneRef a = ZoneRef a => (a, ObjectRef)
data SomeZoneRef where SomeZoneRef :: ZoneRef a => a -> SomeZoneRef
data SomeObjectZoneRef where SomeObjectZoneRef :: ZoneRef a => ObjectZoneRef a -> SomeObjectZoneRef
    
data LibraryZRef = LibraryZRef PlayerRef
data HandZRef = HandZRef PlayerRef
data GraveyardZRef = GraveyardZRef PlayerRef
data ExileZRef = ExileZRef
data BattlefieldZRef = BattlefieldZRef
data StackZRef = StackZRef


instance ZoneRef LibraryZRef where
    type TypeOfZoneObjects LibraryZRef = CardObjTp
    type TypeOfZone LibraryZRef = ZtDeque
    ixZone (LibraryZRef p) = library % ix p
    ixZoneObj (zoneRef, objRef) = ixZone zoneRef % ixObj objRef

instance ZoneRef HandZRef where
    type TypeOfZoneObjects HandZRef = CardObjTp
    type TypeOfZone HandZRef = ZtSet
    ixZone (HandZRef p) = hand % ix p
    ixZoneObj (zoneRef, objRef) = ixZone zoneRef % ixObj objRef

instance ZoneRef GraveyardZRef where
    type TypeOfZoneObjects GraveyardZRef = CardObjTp
    type TypeOfZone GraveyardZRef = ZtSet
    ixZone (GraveyardZRef p) = graveyard % ix p
    ixZoneObj (zoneRef, objRef) = ixZone zoneRef % ixObj objRef

instance ZoneRef ExileZRef where
    type TypeOfZoneObjects ExileZRef = CardObjTp
    type TypeOfZone ExileZRef = ZtSet
    ixZone ExileZRef = castOptic exile
    ixZoneObj (zoneRef, objRef) = ixZone zoneRef % ixObj objRef

instance ZoneRef BattlefieldZRef where
    type TypeOfZoneObjects BattlefieldZRef = PermanentObjTp
    type TypeOfZone BattlefieldZRef = ZtSet
    ixZone BattlefieldZRef = castOptic battlefield
    ixZoneObj (zoneRef, objRef) = ixZone zoneRef % ixObj objRef

instance ZoneRef StackZRef where
    type TypeOfZoneObjects StackZRef = StackItemObjTp
    type TypeOfZone StackZRef = ZtDeque
    ixZone StackZRef = castOptic stack
    ixZoneObj (zoneRef, objRef) = ixZone zoneRef % ixObj objRef




{--
ixZone :: ZoneRef ot -> AffineTraversal' Zones (Zone zt ot)
ixZone (Library p)   = library % ix p
ixZone (Hand p)      = hand % ix p
ixZone (Graveyard p) = graveyard % ix p
ixZone Exile         = castOptic exile
ixZone Battlefield   = castOptic battlefield
ixZone Stack         = castOptic stack
--}



-- !!! Index and IxValue cannot be polymorphic
{--
type instance Index Zones = forall a. ZoneRef a -- !!! Index and IxValue cannot be polymorphic
type instance IxValue Zones = forall a. Zone a  -- !!! Index and IxValue cannot be polymorphic
instance Ixed Zones where
    type IxKind Zones = An_AffineTraversal
    ix :: ZoneRef a -> AffineTraversal' Zones (Zone a)
    ix zoneref = atraversal (\zs -> maybeToEither zs (solveZoneRef zoneref)) (\zs z -> modifyZoneRef zoneref (const z) zs)
--}

{-- Zones no longer have homomorphic data structures

ixZone :: ZoneRef a -> AffineTraversal' Zones (Zone a)
ixZone (Library p)   = library % ix p
ixZone (Hand p)      = hand % ix p
ixZone (Graveyard p) = graveyard % ix p
ixZone Exile         = castOptic exile
ixZone Battlefield   = castOptic battlefield
ixZone Stack         = castOptic stack

--}