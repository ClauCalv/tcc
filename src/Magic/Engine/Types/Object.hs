{-# LANGUAGE 
    DuplicateRecordFields, 
    NoFieldSelectors,
    OverloadedRecordDot,
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)
    DataKinds,                     -- Defining new kinds

    PolyKinds,
    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
    DeriveAnyClass
#-}

{-# OPTIONS_GHC -dth-dec-file #-}

module Magic.Engine.Types.Object where

import Magic.Engine.Types.Player
import Magic.Engine.Types.CardType
import Magic.Engine.Types.Ability

import Optics (makeLenses)


-- DATAKIND
data ObjectType = CardObjTp | PermanentObjTp | StackItemObjTp

type CardObject = ObjectOfType CardObjTp
type PermanentObject = ObjectOfType PermanentObjTp
type StackObject = ObjectOfType StackItemObjTp

data ObjectOfType (a :: ObjectType) where
    MkCardObject :: {
        cardObject :: Object
    } -> CardObject
    MkPermanentObject :: {
        originalCardObject :: Maybe Object,
        permanentObject :: Permanent
    } -> PermanentObject
    MkStackItemObject :: {
        originalCardObject :: Maybe Object,
        stackObject :: StackItem
    } -> StackObject

makeLenses ''ObjectOfType

type PowerToughness = (Integer, Integer)

data Object = MkObject {
    _name :: String,
    _owner :: Maybe PlayerRef,
    _controller :: Maybe PlayerRef,
    _types :: CardTypeSet,
    _colors :: ColorSet,
    _powerToughness :: PowerToughness,
    _playAbility :: Maybe Activation,
    _activatedAbilities :: [Ability]
}
data Permanent = MkPermanent {
    _baseObjAttr :: Object,
    _permanentStatus :: PermanentStatus,
    _damage :: Integer
}
data StackItem = MkStackItem {
    _baseObjAttr :: Object,
    _stackAttr :: ()
}

data PermanentStatus = PermanentStatus {
    _tapStatus :: TapStatus,
    _flipStatus :: FlipStatus,
    _faceStatus :: FaceStatus,
    _phaseStatus :: PhaseStatus
} deriving (Eq, Show, Read)

data TapStatus =  Untapped | Tapped
    deriving (Eq, Ord, Enum, Bounded, Show, Read, Cycle)
data FlipStatus = Unflipped | Flipped
    deriving (Eq, Ord, Enum, Bounded, Show, Read, Cycle)
data FaceStatus =  FaceUp | FaceDown
    deriving (Eq, Ord, Enum, Bounded, Show, Read, Cycle)
data PhaseStatus = PhasedIn | PhasedOut
    deriving (Eq, Ord, Enum, Bounded, Show, Read, Cycle)

defaultPermanentStatus :: PermanentStatus
defaultPermanentStatus = PermanentStatus Untapped Unflipped FaceUp PhasedIn

makeLenses ''Object
makeLenses ''Permanent
makeLenses ''StackItem
makeLenses ''PermanentStatus

type Card = PlayerRef -> Object

emptyCard :: Card
emptyCard p = MkObject {
    _name = "",
    _owner = Just p,
    _controller = Just p,
    _types = emptyCTS,
    _colors = ES.empty,
    _powerToughness = (0,0),
    _playAbility = emptyActivation,
    _activatedAbilities = []
}