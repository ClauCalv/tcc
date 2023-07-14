module Magic.Engine.Types.Ability where

import Magic.Server.ServerInterpreter
import Magic.Engine.Types.Player
import Magic.Engine.Types.Effect
import qualified Data.EnumSet as ES
import qualified Data.EnumMultiSet as EMS
import Magic.Engine.Types.Mana (ManaCost)

data AbilityType = SpellAbility | ActivatedAbility | TriggeredAbility | StaticAbility 
    | ManaAbility | LoyaltyAbility | KeywordAbility | EvasionAbility | CharacteristicDefiningAbility
    | IntrinsicAbility | DraftAbility

type AbilityTypeSet = ES.EnumSet abilityType
type EffectActivation = ActivationContext -> Contextual [Effect]

data Ability = MkAbility {
    _abilityTypes :: AbilityTypeSet,
    _activation :: Activation
}

data ActivationContext = MkActivationContext {
    _activator :: Maybe PlayerRef,
    _source :: Maybe (Some ObjectZoneRef),
    _world :: World
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
    abilityTypes = ES.empty,
    activation = emptyActivation
}

emptyActivation :: Activation
emptyActivation = MkActivation {
    prereq = [],
    costs = emptyCosts,
    effects = const $ return []
}

emptyCosts :: Costs
emptyCosts = MkCosts {
    manaCost = EMS.empty,
    otherCosts = Nothing
}