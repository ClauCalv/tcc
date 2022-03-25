{-# LANGUAGE GADTs #-}
{-# LANGUAGE TemplateHaskell #-}

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}

module Types.EntityTypes where

import qualified Data.Dict as D
import Types.Players

--DataKind
data EntityType = TyCard | TyPermanent | TyStackItem


data EntityOfType :: EntityType -> * where
    Card        :: CardEntity       -> EntityOfType TyCard
    Permanent   :: PermanentEntity  -> EntityOfType TyPermanent
    StackItem   :: StackItemEntity  -> EntityOfType TyStackItem

data CardEntity = CardEntity 
    { _cardObject :: Object
    }

data PermanentEntity = PermanentEntity
    { _permanentObject :: Object
    , _tapStatus       :: TapStatus
    , _damage          :: Int
    , _deathtouched    :: Bool
    , _attachedTo      :: Maybe SomeObjectRef
    , _attacking       :: Maybe EntityRef2
    }

data StackItemEntity = StackItemEntity
    { _stackItemObject :: Object
    , _stackItem       :: StackItem
    }

type Object = ()
type TapStatus = ()
type SomeObjectRef = ()
type EntityRef2 = ()
type StackItem = ()

type EntityRef a = (ZoneRef a, D.RefOf (EntityOfType a))
data ZoneRef :: EntityType -> * where
    Library     :: D.RefOf Player ->    ZoneRef TyCard
    Hand        :: D.RefOf Player ->    ZoneRef TyCard
    Graveyard   :: D.RefOf Player ->    ZoneRef TyCard
    Battlefield ::                      ZoneRef TyPermanent
    Stack       ::                      ZoneRef TyStackItem
    Exile       ::                      ZoneRef TyCard
    Command     ::                      ZoneRef TyCard