{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    TypeFamilies,                  -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances          -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Magic.Server.ServerCommunicator.TCPServerCommunicator where

-- from base
--import Control.Applicative
--import Data.Kind (Type)
-- from fused-effects
import Control.Algebra
-- from transformers
import Control.Monad.IO.Class

--import Data.Serializable
import qualified Data.Dict as D
import Control.Carrier.State.Strict (StateC, gets, State, modify, evalState)
import Data.Maybe (fromJust)
import Text.Read (readMaybe)
import System.Exit (die)

import Magic.Server.ServerCommunicator
import Control.Carrier.Lift (runM)
import Control.Concurrent (MVar, putMVar, takeMVar, newEmptyMVar, forkIO)
import Data.Dict (UniqDict(keys))
import Control.Monad (forever)
import Data.IORef (IORef, writeIORef, newIORef, readIORef)

data TCPServerConfig = TCPServerConfig {
    _players :: D.AssocDict ServerPlayerRef TCPServerPlayer,
    _worldCopy :: IORef ServerWorld,
    _input :: MVar (ServerPlayerRef, ServerText),
    _output :: MVar (ServerPlayerRef, ServerText)
}

data TCPServerPlayer = TCPServerPlayer {
    _id :: ServerPlayerRef,
    _name :: ServerText,
    _connection :: (Int, Int)
}

newtype TCPServerCommunicator m a = TCPServerCommunicator { runTCPServerCommunicator :: m a }
    deriving (Applicative, Functor, Monad, MonadIO)

type TCPServerCommunicatorConstraint sig m = (MonadIO m, Has (State TCPServerConfig) sig m, Algebra sig m)

instance TCPServerCommunicatorConstraint sig m => Algebra (ServerCommunicator :+: sig) (TCPServerCommunicator m) where
  alg hdl sig ctx = case sig of
    L (ServerCommunication c) -> (<$ ctx) <$> doCommunicate c
    R other -> TCPServerCommunicator (alg (runTCPServerCommunicator . hdl) other ctx)

doCommunicate :: TCPServerCommunicatorConstraint sig m => ServerCommunication a -> m a
doCommunicate (BroadcastMessage t) = do
    output <- gets _output
    players <- gets _players
    liftIO . mapM_ (\k -> putMVar output (k, t)) . keys $ players
doCommunicate (SendMessage p t) = do
    output <- gets _output
    liftIO . putMVar output $ (p, t)
doCommunicate (WaitAnswer p) = do
    input <- gets _input
    (p', m) <- liftIO . takeMVar $ input
    if p == p' then return (Just m) else do
        doCommunicate (SendMessage p' "No Pending Question To Answer!!")
        doCommunicate (WaitAnswer p)
doCommunicate (UpdateWorld w) = do
    world <- gets _worldCopy
    liftIO . writeIORef world $ w

initialTCPServerConfig :: IORef ServerWorld -> MVar (ServerPlayerRef, ServerText) -> MVar (ServerPlayerRef, ServerText) -> TCPServerConfig
initialTCPServerConfig = TCPServerConfig D.empty

-------------- TESTS ----------

withConsoleServerCommunicator :: TCPServerConfig -> IO ()
withConsoleServerCommunicator s = runM . evalState s . runTCPServerCommunicator $ foo

foo :: (Has ServerCommunicator sig m, Has (State TCPServerConfig) sig m) => m ()
foo = do
    fstPlayer <- gets $ fromJust . D.find 0 . _players
    send . ServerCommunication . BroadcastMessage $ _name fstPlayer ++ ", what is your favorite color?"
    color <- send . ServerCommunication . WaitAnswer $ _id fstPlayer
    send . ServerCommunication . BroadcastMessage $ "Wow! I also like " ++ fromJust color

startFoo :: IO ()
startFoo = do
    input <- newEmptyMVar
    output <- newEmptyMVar
    world <- newIORef ""
    let cfg = initialTCPServerConfig world input output
    forkIO $ tcpInputLoop input world
    forkIO $ tcpOutputLoop output
    withConsoleServerCommunicator cfg

tcpInputLoop :: MVar (ServerPlayerRef, ServerText) -> IORef ServerWorld -> IO ()
tcpInputLoop input world = forever $ do
    (p, msg) <- waitComm
    case readMaybe @ServerCommand msg of
        Nothing -> sendMessageTCP p "Cannot parse command, try again"
        Just (Answer s) -> putMVar input (p, s)
        Just ViewWorld -> do
            w <- readIORef world
            sendMessageTCP p $ "Showing game world:\n" ++ w
        Just ForceQuit -> liftIO $ die "Game Forcefully Closed"

tcpOutputLoop :: MVar (ServerPlayerRef, ServerText) -> IO ()
tcpOutputLoop output = forever $ do
    (p, msg) <- takeMVar output
    sendMessageTCP p msg

waitComm :: IO (ServerPlayerRef, ServerText)
waitComm = undefined

sendMessageTCP :: ServerPlayerRef -> ServerText -> IO ()
sendMessageTCP = undefined