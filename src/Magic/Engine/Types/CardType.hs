{-# LANGUAGE TemplateHaskell #-}

module Magic.Engine.Types.CardType where

import qualified Data.EnumSet as ES
import Optics (makeLenses)

data SuperType = Basic | Legendary -- | Snow | World | Ongoing | Elite | Host
    deriving (Eq, Ord, Enum, Bounded)
data CardType = Land | Creature | Artifact | Enchantment | Planeswalker 
    | Instant | Sorcery
    -- | Tribal | Dungeon | Battle | Hero | Elemental
    -- | Phenomenon | Plane | Scheme | Vanguard | Conspiracy
    deriving (Eq, Ord, Enum, Bounded)
data SubType = Equipment | Aura | Saga | Vehicle | Wall | Lesson -- @todo remodel as several sets
    deriving (Eq, Ord, Enum, Bounded)

type SuperTypes = ES.EnumSet SuperType
type CardTypes = ES.EnumSet CardType
type SubTypes = ES.EnumSet SubType

data CardTypeSet = CardTypeSet {
    _superTypes :: SuperTypes, 
    _cardTypes :: CardTypes, 
    _subTypes :: SubTypes
}

makeLenses ''CardTypeSet

emptyCTS :: CardTypeSet
emptyCTS = CardTypeSet ES.empty ES.empty ES.empty