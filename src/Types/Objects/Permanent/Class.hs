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

module Types.Objects.Permanent.Class where

import Optics

import Data.Class.Wrap

import Types.Cards.CardTypes
import qualified Data.EnumSet as ES

import Types.Objects.Object

import Types.Objects.Permanent.Lenses

type Permanent = Wrap IsPermanent

-- @todo finish class
class (IsObject a, HasPermanentStatus a) => IsPermanent a where
   --

-- @todo implement CR 110.4
-- @default aaaaa
permanentCardTypes :: CardTypes
permanentCardTypes = ES.empty