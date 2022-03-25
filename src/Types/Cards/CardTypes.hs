module Types.Cards.CardTypes where

import qualified Data.EnumSet as ES

data CardTypeSet = CardTypeSet SuperTypes CardTypes SubTypes

type SuperTypes = ES.EnumSet SuperType
type CardTypes = ES.EnumSet CardType
type SubTypes = ES.EnumSet SubType

data SuperType = AAAA
data CardType = BBBB
data SubType = CCCC
