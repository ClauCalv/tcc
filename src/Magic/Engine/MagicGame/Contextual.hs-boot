module Magic.Engine.MagicGame.Contextual where

data Contextual a

instance Functor Contextual
instance Applicative Contextual
instance Monad Contextual