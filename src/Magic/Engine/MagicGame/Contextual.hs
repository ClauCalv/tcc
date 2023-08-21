module Magic.Engine.MagicGame.Contextual where
    
import Control.Algebra

import Magic.Server.ServerInterpreter
import Magic.Engine.MagicGame

import {-# SOURCE #-} Magic.Engine.Types.Player

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
