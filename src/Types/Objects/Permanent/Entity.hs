{-# LANGUAGE 
    DuplicateRecordFields           -- For declaring fields with same name in different records

    -- ExistentialQuantification,   -- Advanced types
    -- RankNTypes,                  -- Advanced types

    --DataKinds,                    -- Defining new kinds
    --KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    --GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    --TypeFamilies,                 -- Alternative to GADTs, defines type equality (= fixating a type variable)

    --MultiParamTypeClasses,        -- Defining complex classes (like Algebra)
    -- FlexibleContexts,            -- Using complex classes in constraints
    --FlexibleInstances,            -- Implementing complex classes' instances (like Algebra)
    --UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)

    --TypeOperators,                -- Needed for composing types like sig

    -- TypeApplications,            -- Defining type in expression via @
    -- OverloadedStrings,           -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving   -- Code shortening, unnecessary but useful.

    --TemplateHaskell               -- For automatic code generation
#-}

module Types.Objects.Permanent.Entity where

import Data.Class.Cycle

data PermanentStatus = PermanentStatus {
    _tapStatus :: TapStatus,
    _flipStatus :: FlipStatus,
    _faceStatus :: FaceStatus,
    _phaseStatus :: PhaseStatus
} deriving (Eq, Show, Read)

data TapStatus =  Untapped | Tapped
    deriving (Eq, Ord, Enum, Bounded, Show, Read)
data FlipStatus = Unflipped | Flipped
    deriving (Eq, Ord, Enum, Bounded, Show, Read)
data FaceStatus =  FaceUp | FaceDown
    deriving (Eq, Ord, Enum, Bounded, Show, Read)
data PhaseStatus = PhasedIn | PhasedOut
    deriving (Eq, Ord, Enum, Bounded, Show, Read)

instance Cycle TapStatus
instance Cycle FlipStatus
instance Cycle FaceStatus
instance Cycle PhaseStatus

defaultPermanentStatus :: PermanentStatus
defaultPermanentStatus = PermanentStatus Untapped Unflipped FaceUp PhasedIn