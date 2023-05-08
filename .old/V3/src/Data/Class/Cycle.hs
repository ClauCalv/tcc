{-# LANGUAGE ScopedTypeVariables #-}

module Data.Class.Cycle where

class (Enum a, Bounded a) => Cycle a where
    next :: a -> a
    next x  | from x < from maxBound = succ x 
            | otherwise              = minBound
                where from :: a -> Int; from = fromEnum 
    prev :: a -> a
    prev x  | from x > from minBound = pred x 
            | otherwise              = maxBound
                where from :: a -> Int; from = fromEnum 

    