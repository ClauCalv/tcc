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

module Types.Objects.Token.Entity where

data TokenFlags = TokenFlags {
    -- following CR 111.8
    triedChangeZone :: Bool
} deriving (Eq, Show, Read)