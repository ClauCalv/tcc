module Magic.Engine.MagicGame where

import Control.Algebra
-- from transformers
import Control.Monad.IO.Class

--import Data.Serializable
import qualified Data.Dict as D
import Control.Carrier.State.Strict (StateC, gets, State, modify, evalState)
import Control.Carrier.Lift (runM)

import Data.Maybe (fromJust)
import Text.Read (readMaybe)
import System.Exit (die)

import Magic.Server.ServerInterpreter
import Magic.Engine.Types.Player
import Magic.Engine.Types.World
import Magic.Engine.Types.Object
    
data MagicGameCommand a where
    RunServerInstruction :: ServerInstruction PlayerRef a -> m a

data MagicGame (m :: * -> *) k where
    MagicGameCommand :: MagicGameCommand a -> MagicGame m a

type Card = PlayerRef -> Object

data MagicGameConfig = MagicGameConfig {
    _playersMap :: D.AssocDict PlayerRef ServerPlayerRef,
    _playersCards :: D.AssocDict ServerPlayerRef [Card],
    _TODO :: ()
}

runServerInstruction :: Has MagicGame sig m => ServerInstruction PlayerRef a -> m a
runServerInstruction = send . MagicGameCommand . RunServerInstruction

newtype DefaultMagicGame m a = DefaultMagicGame { runDefaultMagicGame :: m a }
    deriving (Applicative, Functor, Monad, MonadIO)

type DefaultMagicGameConstraint sig m = (
    MonadIO m, 
    Has ServerInterpreter sig m, 
    Has (Reader ConsoleServerConfig) sig m, 
    Has (State World) sig m, 
    Algebra sig m )

instance DefaultMagicGameConstraint sig m => Algebra (MagicGame :+: sig) (DefaultMagicGame m) where
  alg hdl sig ctx = case sig of
    L (MagicGame c) -> (<$ ctx) <$> doMagicGameCommand c
    R other -> DefaultMagicGame (alg (runDefaultMagicGame . hdl) other ctx)

worldPlayerToServerPlayer :: DefaultMagicGameConstraint sig m => PlayerRef -> m ServerPlayerRef
worldPlayerToServerPlayer p = do
    ps <- asks _playersMap
    return $ D.find p ps

doMagicGameCommand :: DefaultMagicGameConstraint sig m => MagicGameCommand a -> m a
doMagicGameCommand (RunServerInstruction i) = case i of
    (BroadcastMessageInst t) -> broadcastMessageInst t
    (SendMessageInst p t) -> worldPlayerToServerPlayer p >>= \p' -> sendMessageInst p' t
    (SendQuestionInst p t q v) -> worldPlayerToServerPlayer p >>= \p' -> sendQuestionInst 'p t q v


startMagicGame :: (MonadIO m, Has ServerInterpreter sig m) => ConsoleServerConfig -> m ()
startMagicGame config = let (world, config') = setupGame config in
    runReader config . runState emptyWorld . runDefaultGameEngine $ startGame

data Contextual a where
    CVal :: a -> Contextual a
    CInst :: ServerInstruction PlayerRef a -> Contextual a
    CThen :: Contextual b -> (b -> Contextual a) -> Contextual a

instance Functor Contextual where
    fmap :: (a -> b) -> Contextual a -> Contextual b
    fmap f (CVal v) = CVal (f v)
    fmap f (CInst i) = CThen (CInst i) (CVal . f)
    fmap f (CThen c cs) = CThen c (fmap f . cs)

instance Applicative Contextual where
    pure :: a -> Contextual a
    pure = CVal

    (<*>) :: Contextual (a -> b) -> Contextual a -> Contextual b
    (CVal f) <*> cs = fmap f cs
    (CInst i) <*> cs = CThen (CInst i) (`fmap` cs)
    (CThen c cf) <*> cs = CThen (CThen c cf) (`fmap` cs)

instance Monad Contextual where
    (>>=) :: Contextual a -> (a -> Contextual b) -> Contextual b
    q >>= f = CThen q f

runContextual :: Has MagicGame sig m => Contextual a -> m a
runContextual (CVal v) = return v
runContextual (CInst i) = runServerInstruction i
runContextual (CThen c cs) = runContextual c >>= runContextual . cs

{--
destroyTargetPlayersPermanentAtHisChoice :: World -> PlayerRef -> Contextual [Effect]
destroyTargetPlayersPermanentAtHisChoice w p = do
    targetPlayer <- CInstr $ choosePlayer w p
    targetObject <- CInstr $ choosePermanentYouControl w targetPlayer
    return [Destroy Nothing targetObject False]
--}