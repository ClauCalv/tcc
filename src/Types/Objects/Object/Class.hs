{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    DataKinds,                    -- Defining new kinds
    -- KindSignatures,            -- Defining types that consumes kinds other than Type (like Type -> Type)
    -- GADTs                      -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra or Is)
    FlexibleContexts              -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Types.Objects.Object.Class where

import Optics

import Data.Class.Wrap

import Types.Objects.Object.Lenses

type Object = Wrap IsObject

-- following *CR 109.3*
data ObjectType = StackAbility | CardObject | CardCopy | Token |
    Spell | Permanent | Emblem
        deriving (Eq, Ord, Enum, Bounded, Show, Read)

-- @todo finish class
class HasBaseObject a => IsObject a where
    objectType :: a -> ObjectType
    --toCardObject :: IsCardObject b => a -> Maybe b