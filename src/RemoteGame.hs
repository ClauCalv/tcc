{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    -- KindSignatures,            -- Defining types that consumes kinds other than Type (like Type -> Type)
    -- GADTs,                     -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    --TypeOperators,              -- Needed for composing types like sig

    TypeApplications              -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module RemoteGame where
    
-- from transformers
import Control.Monad.IO.Class
-- from fused-effects
import Control.Carrier.State.Strict

import Effects.Server.RemoteServer
import Effects.IOFormatter

newtype ServerState = ServerState ()

-- Setup server effects
startRemoteGame :: IO ()
startRemoteGame = runIOFormatter @String $
                  evalState initialState $
                  runRemoteServer $
                      startServer

initialState :: ServerState
initialState = ServerState ()

startServer :: (MonadIO m, Has E_Server sig m) => m ()
startServer = liftIO . putStrLn $ "Remote Server On"