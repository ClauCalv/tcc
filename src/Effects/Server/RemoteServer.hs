{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    -- KindSignatures,            -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    MultiParamTypeClasses,        -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    FlexibleInstances,            -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    TypeOperators,                -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    GeneralizedNewtypeDeriving    -- Code shortening, unnecessary but useful.
#-}

module Effects.Server.RemoteServer  (
  module Effects.Server.RemoteServer,
  module Effects.Server
) where

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
-- From Effects
import Effects.Server
import Effects.IOFormatter

-- Remote server impl

newtype C_RemoteServer m a = C_RemoteServer { runRemoteServer :: m a }
  deriving (Applicative, Functor, Monad, MonadIO)

--Meaning: 'C_RemoteServer m' implements 'E_Server', only if 'm is MonadIO', depending on 'E_IOFormatter'
instance (MonadIO m, 
          Has (E_IOFormatter String) sig m,
          Algebra sig m
          ) => Algebra (E_Server :+: sig) (C_RemoteServer m) where
  alg hdl sig ctx = case sig of
    L (RunInstruction i) -> (<$ ctx) <$> doRunInstruction i
    R other      -> C_RemoteServer (alg (runRemoteServer . hdl) other ctx)

doRunInstruction :: (MonadIO m, Has (E_IOFormatter String) sig m, Read a) => Instruction b a -> m a
doRunInstruction i = case i of
    (Broadcast a)   -> return ()
    (Send p a)      -> return ()
    (Ask p a q)     -> return (read "")
    (Choose p a bs) -> return (head bs)
    (MaybeChoose p a bs) -> return Nothing
  


