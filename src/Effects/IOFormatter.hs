{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    MultiParamTypeClasses,        -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    FlexibleInstances,            -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    TypeOperators,                -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Effects.IOFormatter where


-- from base
import Control.Applicative
import Data.Kind (Type)
-- from transformers
import Control.Monad.IO.Class
-- from fused-effects
import Control.Algebra
-- From aeson
--import Data.Aeson
-- From bytestring
--import qualified Data.ByteString.Char8 as B
--import qualified Data.ByteString.Lazy as L


-- IOFormatter specification

data E_IOFormatter b (m :: Type -> Type) k where
  ShowFormatted :: (SerializableAs b a) => a -> E_IOFormatter b m b
  ReadFormatted :: (SerializableAs b a) => b -> E_IOFormatter b m a

showFormatted :: (Has (E_IOFormatter b) sig m, SerializableAs b a) => a -> m b
showFormatted m = send (ShowFormatted m)

readFormatted :: (Has (E_IOFormatter b) sig m, SerializableAs b a) => b -> m a
readFormatted s = send (ReadFormatted s)


-- IOFormatter implementation

newtype C_IOFormatter b m a = C_IOFormatter { runIOFormatter :: m a }
  deriving (Applicative, Functor, Monad, MonadIO)

--Meaning: 'C_IOFormatter m' implements 'E_IOFormatter'
instance (Algebra sig m) => Algebra (E_IOFormatter b :+: sig) (C_IOFormatter b m) where
  alg hdl sig ctx = case sig of
    L (ShowFormatted m) -> (<$ ctx) <$> doShowFormatted m
    L (ReadFormatted s) -> (<$ ctx) <$> doReadFormatted s
    R other      -> C_IOFormatter (alg (runIOFormatter . hdl) other ctx)

doShowFormatted :: (Monad m, SerializableAs b a) => a -> m b
doShowFormatted ds = return $ serialize ds

doReadFormatted :: (Monad m, SerializableAs b a) => b -> m a
doReadFormatted s = return $ deserialize s


-- Serialization Constraint

class SerializableAs b a where
  serialize :: a -> b
  deserialize :: b -> a

instance SerializableAs String String where
  serialize = id
  deserialize = id