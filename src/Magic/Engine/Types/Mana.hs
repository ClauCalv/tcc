{-# LANGUAGE 
    StandaloneDeriving       -- for deriving Bounded
#-}

module Magic.Engine.Types.Mana where

import qualified Data.EnumMultiSet as EMS

import Magic.Engine.Types.Color

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

--------

data ManaCostEl = GenericManaCost | SpecificManaCost Mana

instance Bounded ManaCostEl where
    minBound = GenericManaCost
    maxBound = SpecificManaCost maxBound

instance Enum ManaCostEl where
    fromEnum GenericManaCost = 0
    fromEnum (SpecificManaCost c) = 1 + fromEnum c
    toEnum 0 = GenericManaCost
    toEnum x = SpecificManaCost . toEnum $ (x - 1)

type ManaCost = EMS.EnumMultiSet ManaCostEl



