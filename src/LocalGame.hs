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

    TypeApplications,             -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]

    TemplateHaskell               -- Code autogeneration
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module LocalGame where
    
import Data.Maybe
-- from transformers
import Control.Monad.IO.Class
-- from fused-effects
import Control.Carrier.State.Strict
-- from optics
import Optics
import Optics.TH
-- from fused-effects-optics
import Control.Effect.Optics

import Effects.Server.LocalServer
import Effects.IOFormatter

import Types.MagicGameTypes

{--

data LocalServerConfig = LocalServerConfig 
    { _nOfPlayers  :: Maybe Int
    , _players     :: [(ServerPlayerRef, LocalServerPlayer)]
    , _gameMode    :: Maybe GameMode
    }

data LocalServerPlayer = LocalServerPlayer 
    {  _name :: String
    } deriving (Show)

makeLenses ''LocalServerConfig
makeLenses ''LocalServerPlayer

makePrisms ''LocalServerConfig
makePrisms ''LocalServerPlayer

initialConfig :: LocalServerConfig
initialConfig = LocalServerConfig Nothing [] Nothing

-- TODO actual server config loop
serverConfigLoop :: (MonadIO m, Has (State LocalServerConfig) sig m) => m GameInitialParams
serverConfigLoop = do
    put $ LocalServerConfig (Just 2) [(0, LocalServerPlayer "Armando"), (1, LocalServerPlayer "Benedito")] (Just Standart)
    ps <- uses players (map fst)
    gm <- uses gameMode fromJust
    return $ GameInitialParams ps gm
    
-- Setup server effects
startLocalGame :: IO ()
startLocalGame =  runIOFormatter @String $
                  evalState initialConfig $ 
                  runLocalServer $ 
                    do
                        liftIO . putStrLn $ "Local Server On"
                        config <- serverConfigLoop
                        startGame config

--}