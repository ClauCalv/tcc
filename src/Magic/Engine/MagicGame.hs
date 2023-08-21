{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    TypeFamilies,                  -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
    TemplateHaskell
#-}

module Magic.Engine.MagicGame where

import Control.Algebra
import Control.Effect.State
import Control.Effect.Reader
import Control.Effect.Lift

import Control.Monad.IO.Class

import qualified Magic.Data.Dict as D

import Data.Maybe (fromJust)
import Text.Read (readMaybe)
import System.Exit (die)

import Magic.Server.ServerCommunicator
import Magic.Server.ServerInterpreter

import Optics (makeLenses)

import {-# SOURCE #-} Magic.Engine.Types.Player
import {-# SOURCE #-} Magic.Engine.Types.World
import {-# SOURCE #-} Magic.Engine.Types.Object
import Language.Haskell.TH (Extension(TemplateHaskell))
    
data MagicGameCommand a where
    RunServerInstruction :: ServerInstruction PlayerRef a -> MagicGameCommand a

data MagicGame (m :: * -> *) k where
    MagicGameCommand :: MagicGameCommand a -> MagicGame m a

data MagicGameConfig = MagicGameConfig {
    _playersMap :: D.AssocList PlayerRef ServerPlayerRef,
    _playersCards :: D.AssocList PlayerRef [Card]
}
emptyMagicGameConfig :: MagicGameConfig
emptyMagicGameConfig = MagicGameConfig [] []

makeLenses ''MagicGameConfig

runServerInstruction :: Has MagicGame sig m => ServerInstruction PlayerRef a -> m a
runServerInstruction = send . MagicGameCommand . RunServerInstruction

newtype DefaultMagicGame m a = DefaultMagicGame { runDefaultMagicGame :: m a }
    deriving (Applicative, Functor, Monad, MonadIO)

type DefaultMagicGameConstraint sig m = (
    MonadIO m, 
    Has ServerInterpreter sig m, 
    Has (Reader MagicGameConfig) sig m, 
    Has (State MagicWorld) sig m, 
    Algebra sig m )

instance DefaultMagicGameConstraint sig m => Algebra (MagicGame :+: sig) (DefaultMagicGame m) where
  alg hdl sig ctx = case sig of
    L (MagicGameCommand c) -> (<$ ctx) <$> doMagicGameCommand c
    R other -> DefaultMagicGame (alg (runDefaultMagicGame . hdl) other ctx)

worldPlayerToServerPlayer :: DefaultMagicGameConstraint sig m => PlayerRef -> m ServerPlayerRef
worldPlayerToServerPlayer p = do
    ps <- asks _playersMap
    return . fromJust $ D.find p ps

doMagicGameCommand :: DefaultMagicGameConstraint sig m => MagicGameCommand a -> m a
doMagicGameCommand (RunServerInstruction i) = case i of
    (BroadcastMessageInst t) -> broadcastMessageInst t
    (SendMessageInst p t) -> worldPlayerToServerPlayer p >>= \p' -> sendMessageInst p' t
    (SendQuestionInst p t q v) -> worldPlayerToServerPlayer p >>= (\p' -> sendQuestionInst p' t q v)

{-
startMagicGame :: (MonadIO m, Has ServerInterpreter sig m) => ConsoleServerConfig -> m ()
startMagicGame config = let (world, config') = setupGame config in
    runReader config . runState emptyWorld . runDefaultGameEngine $ startGame
-}