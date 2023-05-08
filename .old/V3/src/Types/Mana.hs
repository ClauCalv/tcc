{-# LANGUAGE 
    StandaloneDeriving       -- for deriving Bounded
#-}

module Types.Mana where

import qualified Data.EnumMultiSet as EMS

import Types.Colors

data Mana = ColorlessMana | ColoredMana Color
    deriving (Eq, Ord, Show, Read)

instance Bounded Mana where
    minBound = ColorlessMana
    maxBound = ColoredMana maxBound

instance Enum Mana where
    fromEnum ColorlessMana = 0
    fromEnum (ColoredMana c) = 1 + fromEnum c
    toEnum 0 = ColorlessMana
    toEnum x = ColoredMana . toEnum $ (x - 1)

type ManaPool = EMS.EnumMultiSet Mana



