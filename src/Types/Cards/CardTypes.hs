module Types.Cards.CardTypes where

import qualified Data.EnumSet as ES

data CardTypeSet = CardTypeSet SuperTypes CardTypes SubTypes

type SuperTypes = ES.EnumSet SuperType
type CardTypes = ES.EnumSet CardType
type SubTypes = ES.EnumSet SubType

data SuperType = AAAA   -- @todo list all supertypes
data CardType = BBBB    -- @todo list all cardtypes
data SubType = CCCC     -- @todo list all subtypes

emptyCTS :: CardTypeSet
emptyCTS = CardTypeSet ES.empty ES.empty ES.empty