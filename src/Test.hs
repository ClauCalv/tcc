{-# LANGUAGE 
    DuplicateRecordFields, 
    NoFieldSelectors,
    OverloadedRecordDot,
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)
    DataKinds,                     -- Defining new kinds

    PolyKinds
    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Test where
import Data.Maybe (fromMaybe, fromJust)

{--

data TODO = TODO'

{- sketch:

    card = "object generator"
    ability = "effect generator"
    object = all elements that can stay in zones
    effect = changes to be applied to the gameState
    zone = places that objects stay

    battlefield = zone where only lives tokens and cardPermanents
    stack = zone where only lives spells and abilitiesObjects
    hand, graveyard, exile = zone where only live cardObjects

    cardObject = card representation in-game

    permanent = object that stays in battlefield, can be tokens or cardPermanents
    token = permanent that, when moved out of battlefield, ceases to exist
    cardPermanent = permanent that, when moved out of battlefield, transforms in cardObject again

    stackObject = object that stays in stack, can be spells or abilitiesObjects
    spell = stackObject caused by activation of a card, can be cardSpell or copySpell
    cardSpell = spell that, when moved out of stack, becomes a cardPermanent or generates a effect then becomes a cardObject
    copySpell = spell that, when moved out of stack, becomes a token or generates a effect then ceases to exist
    abilityObject = stackObject caused by activation of ability, when moved out of stack, generates a effect then ceases to exist

-}

data Some (f :: a -> *) where 
    MkSome :: f a -> Some f

data Color = W | U | R | G | B
data Mana = Colored Color | Colorless
data ManaCost = Specific Mana | Generic
type ManaTotal = [(Integer, Mana)]
type ManaCostTotal = [(Integer, ManaCost)]

type Card = PlayerRef -> Object

data AbilityType = ManaAbility | ActivatedAbility | Other
data Ability = MkAbility {
    abilityType :: AbilityType,
    activation :: Activation
}

data World = MkWorld {
    players :: Dict PlayerRef Player,
    zones :: Zones
}

emptyObject :: Object
emptyObject = MkObject {
    name = "",
    owner = Nothing,
    controller = Nothing,
    types  = [],
    powerToughness = Nothing,
    playAbility = Nothing,
    activatedAbilities = []
}

data Void

noQuestionEffect :: [Effect] -> EffectActivation
noQuestionEffect efs _ = MkSome $ MkEffectApplication(QuestionVoid, const efs)

noEffect :: EffectActivation
noEffect = noQuestionEffect []

simplePlayActivation :: Timing -> ManaCostTotal -> EffectActivation -> Activation
simplePlayActivation t m e = MkActivation {
    prereq = [(t, OnHand)],
    costs = MkCosts{manaCost = m, otherCosts = Nothing},
    effects = e
}

activationSource :: ActivationContext -> Some ObjectZoneRef
activationSource MkActivationContext{source = s} = fromJust s

activationPlayer :: ActivationContext -> PlayerRef
activationPlayer MkActivationContext{activator = a} = fromJust a

tapSelf :: EffectActivation
tapSelf ac = noQuestionEffect [TapObject (activationSource ac)] ac

simpleManaAbility :: ManaCostTotal -> ManaTotal -> Ability
simpleManaAbility mc mt = MkAbility ManaAbility $ MkActivation {
    prereq = [(ManaTime, OnField)],
    costs = MkCosts{manaCost = mc, otherCosts = Just tapSelf},
    effects = \ac -> noQuestionEffect [GainMana (activationPlayer ac) mt] ac
}

basicLand :: Mana -> Card
basicLand m p = emptyObject {
    name = "Land test",
    owner = Just p,
    types = [Land],
    playAbility = Just $ simplePlayActivation LandTime [] noEffect,
    activatedAbilities = [simpleManaAbility [] [(1, m)]]
}

basicCreature :: ManaCostTotal -> (Int,Int) -> Card
basicCreature mc pt p = emptyObject {
    name = "Creature test",
    owner = Just p,
    types = [Creature],
    playAbility = Just $ simplePlayActivation SorcTime mc noEffect,
    powerToughness = Just pt
}

basicDealDamage :: ManaCostTotal -> Integer -> Card
basicDealDamage mc d p = emptyObject {
    name = "Spell damage test",
    owner = Just p,
    types = [Creature],
    playAbility = Just $ simplePlayActivation InstTime mc (dealDmg d)
} where 
    dealDmg d MkActivationContext{activator = p, world = w, source = s} = (question p w, \t -> dealDmgEffect (findSource w s) d t)
    question p w = QuestionTargetPlayerOrPermanent (fromJust p) w
    findSource w s = fromJust $ findObject w (fromJust s)
    dealDmgEffect so d t = [DealDamage so d t] 

findObject :: World -> ObjectZoneRef a -> ObjectOfType a
findObject w (MkObjectZoneRef zr or) = case zr of
    Library     a -> lookupJust or $ (lookupJust a (w.zones.library)).objects
    Hand        a -> lookupJust or $ (lookupJust a (w.zones.hand)).objects
    Graveyard   a -> lookupJust or $ (lookupJust a (w.zones.graveyard)).objects
    Exile         -> lookupJust or w.zones.exile.objects
    Battlefield   -> lookupJust or w.zones.battlefield.objects
    Stack         -> lookupJust or w.zones.stack.objects
    where lookupJust x xs = fromJust $ lookup x xs



choosePlayer :: World -> PlayerRef -> Instruction PlayerRef
choosePlayer w p = QuestionPlayer (ChooseOne ps) "Choose target player" p val
    where
        ps = map fst w.players
        val x = if x `elem` ps then Right x else Left "Invalid target, choose again"

choosePermanentYouControl :: World -> PlayerRef -> Instruction (ObjectZoneRef PermanentObjTp)
choosePermanentYouControl w p = QuestionPlayer (ChooseOne ors) "Choose target permanent you control" p val
    where 
        ors = map fst . filter (\(or,o) -> o.owner == p) $ w.zones.battlefield.objects
        val x = if x `elem` ors then Right (MkObjectZoneRef Battlefield x) else Left "Invalid target, choose again"

destroyTargetPlayersPermanentAtHisChoice :: World -> PlayerRef -> Contextual [Effect]
destroyTargetPlayersPermanentAtHisChoice w p = do
    targetPlayer <- CInstr $ choosePlayer w p
    targetObject <- CInstr $ choosePermanentYouControl w targetPlayer
    return [Destroy Nothing targetObject False]

--}