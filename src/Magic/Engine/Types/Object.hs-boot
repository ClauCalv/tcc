{-# LANGUAGE TypeFamilies, DataKinds #-}
module Magic.Engine.Types.Object where

import {-# SOURCE #-} Magic.Engine.Types.Player

type Card = PlayerRef -> Object
type PowerToughness = (Integer, Integer)

-- DATAKIND
data ObjectType = CardObjTp | PermanentObjTp | StackItemObjTp
type family ObjectOfType (a :: ObjectType) where
    ObjectOfType CardObjTp      = CardObject
    ObjectOfType PermanentObjTp = PermanentObject
    ObjectOfType StackItemObjTp = StackObject
    
data CardObject
data PermanentObject
data StackObject

data Object
data Permanent
data StackItem