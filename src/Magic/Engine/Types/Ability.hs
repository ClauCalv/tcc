{-# LANGUAGE TemplateHaskell #-}
module Magic.Engine.Types.Ability where

import {-# SOURCE #-} Magic.Engine.MagicGame.Contextual

import {-# SOURCE #-} Magic.Engine.Types.World
import Magic.Engine.Types.Player
import {-# SOURCE #-} Magic.Engine.Types.Effect
import Magic.Engine.Types.Mana
import Magic.Engine.Types.Zone

import qualified Data.EnumSet as ES
import qualified Data.EnumMultiSet as EMS
import Data.Class.Wrap

import Optics


data AbilityType = SpellAbility | ActivatedAbility | TriggeredAbility | StaticAbility 
    | ManaAbility | LoyaltyAbility | KeywordAbility | EvasionAbility | CharacteristicDefiningAbility
    | IntrinsicAbility | DraftAbility
    deriving (Eq, Ord, Enum, Bounded)

type AbilityTypeSet = ES.EnumSet AbilityType
type EffectActivation = ActivationContext -> Contextual [Wrap Effect]

data Ability = MkAbility {
    _abilityTypes :: AbilityTypeSet,
    _activation :: Activation
}

data ActivationContext = MkActivationContext {
    _activator :: Maybe PlayerRef,
    _source :: Maybe SomeObjectZoneRef,
    _world :: MagicWorld
}

data Timing = LandTime | SorcTime | InstTime | ManaTime
data Placing = OnHand | OnField 

data Activation = MkActivation {
    _prereq :: [(Timing, Placing)],
    _costs :: Costs,
    _effects :: EffectActivation
}

data Costs = MkCosts {
    _manaCost :: ManaCost,
    _otherCosts :: Maybe EffectActivation
}

makeLenses ''Ability
makeLenses ''ActivationContext
makeLenses ''Activation
makeLenses ''Costs

emptyAbility :: Ability
emptyAbility = MkAbility {
    _abilityTypes = ES.empty,
    _activation = emptyActivation
}

emptyActivation :: Activation
emptyActivation = MkActivation {
    _prereq = [],
    _costs = emptyCosts,
    _effects = const $ return []
}

emptyCosts :: Costs
emptyCosts = MkCosts {
    _manaCost = EMS.empty,
    _otherCosts = Nothing
}