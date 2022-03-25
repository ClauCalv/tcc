{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs                         -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Effects.Server where


-- from base
import Control.Applicative
import Data.Kind (Type)
-- from fused-effects
import Control.Algebra
-- from transformers
import Control.Monad.IO.Class
-- From aeson
--import Data.Aeson
-- From bytestring
--import qualified Data.ByteString.Char8 as B
--import qualified Data.ByteString.Lazy as L
-- From time
--import Data.Time.Clock
-- From http-client
--import qualified Network.HTTP.Client as HTTP
--import Network.HTTP.Client.Internal (Response(..), ResponseClose(..))
-- From http-client-tls
--import qualified Network.HTTP.Client.TLS as HTTP
-- From http-status
--import Network.HTTP.Types.Header
--import Network.HTTP.Types.Status
--import Network.HTTP.Types.Version


-- Server specification

data E_Server (m :: Type -> Type) k where
  RunInstruction :: (Show a, Read b) => Instruction a b -> E_Server m b

runInstruction :: (Show a, Read b) => Has E_Server sig m => Instruction a b -> m b
runInstruction i = send $ RunInstruction i

-- Workspace

type ServerPlayerRef = Int;

-- Instruções do programa; interações com as quais o servidor terá que lidar
-- GADT
data Instruction a b where
    Broadcast :: (Show a) => a -> Instruction a ()
    Send :: (Show a) => ServerPlayerRef -> a -> Instruction a ()
    Ask :: (Show a) => ServerPlayerRef -> a -> Question b -> Instruction a b
    Choose :: (Show a, Show b, Read b) => ServerPlayerRef -> a -> [b] -> Instruction a b
    MaybeChoose :: (Show a, Show b, Read b) => ServerPlayerRef -> a -> [b] -> Instruction a (Maybe b)

-- Só pra fazer pattern-matching bom no tipo de retorno
-- GADT
data Question a where
    QuestionNumber :: Question Int
    QuestionText :: Question String
    QuestionEnum :: (Bounded a, Enum a) => Question a
    QuestionSerializable :: (Show a, Read a) => Question a