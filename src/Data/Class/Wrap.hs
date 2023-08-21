{-# LANGUAGE 
    --DuplicateRecordFields,        -- For declaring fields with same name in different records

    -- ExistentialQuantification,   -- Advanced types
    RankNTypes,                     -- Advanced types

    --DataKinds,                    -- Defining new kinds
    ConstraintKinds,                -- Using higher-kind constraints
    KindSignatures,                 -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                          -- Defining types that fixates a type variable pattern-matching it
    --TypeFamilies,                 -- Alternative to GADTs, defines type equality (= fixating a type variable)

    --MultiParamTypeClasses,        -- Defining complex classes (like Algebra)
    -- FlexibleContexts,            -- Using complex classes in constraints
    FlexibleInstances               -- Implementing complex classes' instances (like Algebra)
    --UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)

    --TypeOperators,                -- Needed for composing types like sig

    -- TypeApplications,            -- Defining type in expression via @
    -- OverloadedStrings,           -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving   -- Code shortening, unnecessary but useful.

    --TemplateHaskell                 -- For automatic code generation
    , ImpredicativeTypes
#-}

module Data.Class.Wrap where

import Data.Typeable
import GHC.Exts

data Some f where
    MkSome :: f a -> Some f

data Wrap (constraint :: * -> Constraint) where 
    MkWrap :: (Typeable a, constraint a) => a -> Wrap constraint

wmap :: (forall a. (Typeable a, constraint a) => a -> b) -> Wrap constraint -> b
wmap f (MkWrap a) = f a

isType :: (Typeable a, constraint a) => Proxy a -> Wrap constraint -> Bool
isType t w = typeRep t == wmap typeOf w

toType :: (Typeable a, constraint a) => Proxy a -> Wrap constraint -> Maybe a
toType t w = wmap cast w

