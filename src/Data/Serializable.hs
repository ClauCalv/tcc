module Data.Serializable where

class Serializable b a where
    serialize :: a -> b
    deserialize :: b -> a

instance (Read a, Show a) => Serializable String a where
    serialize = show
    deserialize = read