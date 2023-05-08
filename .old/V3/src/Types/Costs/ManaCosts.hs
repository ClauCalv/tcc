module Types.Costs.ManaCosts where

import qualified Data.EnumMultiSet as EMS
import Types.Colors

data ManaCostElem = Generic | Colorless | Colored Color
    deriving (Eq, Ord, Show, Read)
     --todo instantiate classes (Bounded, Enum)

type BasicManaCost = EMS.EnumMultiSet ManaCostElem

data ManaCost = 
    EmptyCost |
    BasicManaCost BasicManaCost | 
    SpecialManaCost BasicManaCost [(SpecialManaCostElem, Int)]
        --deriving (Show, Read)

data SpecialManaCostElem = 
    HybridColorColor Color Color | 
    HybridColorGeneric Color |
    PhyrexianColor Color | 
    SnowColor Color |
    SnowAny
        deriving(Eq, Show, Read)
    -- do I Enumerate this?