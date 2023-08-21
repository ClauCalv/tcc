{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    TypeFamilies,                  -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Magic.Server.ServerCommunicator.ConsoleServerCommunicator where


import Control.Algebra
import Control.Carrier.State.Strict (StateC, gets, State, modify, evalState)
import Control.Carrier.Lift (runM)

import Control.Monad.IO.Class
import System.Exit (die)

import Data.Maybe (fromJust)
import Text.Read (readMaybe)

import qualified Magic.Data.Dict as D

import Magic.Server.ServerCommunicator

data ConsoleServerConfig = ConsoleServerConfig {
    _players :: D.AssocDict ServerPlayerRef ConsoleServerPlayer,
    _worldCopy :: ServerWorld,
    _isWaitingAnswer :: Bool
}

data ConsoleServerPlayer = ConsoleServerPlayer {
    _id :: ServerPlayerRef,
    _name :: ServerText
}

newtype ConsoleServerCommunicator m a = ConsoleServerCommunicator { runConsoleServerCommunicator :: m a }
    deriving (Applicative, Functor, Monad, MonadIO)

type ConsoleServerCommunicatorConstraint sig m = (MonadIO m, Has (State ConsoleServerConfig) sig m, Algebra sig m)

instance ConsoleServerCommunicatorConstraint sig m => Algebra (ServerCommunicator :+: sig) (ConsoleServerCommunicator m) where
  alg hdl sig ctx = case sig of
    L (ServerCommunication c) -> (<$ ctx) <$> doCommunicate c
    R other -> ConsoleServerCommunicator (alg (runConsoleServerCommunicator . hdl) other ctx)

doCommunicate :: ConsoleServerCommunicatorConstraint sig m => ServerCommunication a -> m a
doCommunicate (BroadcastMessage t) = liftIO $ putStrLn "Broadcasting message:" >> putStrLn t
doCommunicate (SendMessage p t) = do
    players <- gets _players
    let playerName = _name . fromJust . (`D.find` players) $ p
    liftIO $ do { putStrLn ("Message to player "++playerName++":"); putStrLn t}
doCommunicate (WaitAnswer p) = do
    message <- liftIO getLine
    case readMaybe @ServerCommand message of
        Nothing -> liftIO (putStrLn "Unable to read command") >> return Nothing
        Just (Answer s) -> return (Just s)
        Just ViewWorld -> do
            worldMessage <- gets _worldCopy
            liftIO $ putStrLn "Showing game world:" >> putStrLn worldMessage
            return Nothing
        Just ForceQuit -> liftIO $ die "Game Forcefully Closed"
doCommunicate (UpdateWorld w) = modify (\c -> c{_worldCopy = w})

initialConsoleServerConfig :: ConsoleServerConfig
initialConsoleServerConfig = ConsoleServerConfig D.empty "" False

-------------- TESTS ----------

withConsoleServerCommunicator :: ConsoleServerConfig -> IO ()
withConsoleServerCommunicator s = runM . evalState s . runConsoleServerCommunicator $ foo

foo :: Has ServerCommunicator sig m => m ()
foo = send . ServerCommunication . BroadcastMessage $ "helloWorld"

startFoo :: IO ()
startFoo = withConsoleServerCommunicator initialConsoleServerConfig