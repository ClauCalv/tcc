module Magic.Data.Empty where

class Empty a where
    empty :: a

instance Empty [a] where
    empty = []

instance Empty (Maybe a) where
    empty = Nothing