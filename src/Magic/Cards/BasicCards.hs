module Magic.Cards.BasicCards where

import Magic.Engine.Types.Player
import Magic.Engine.Types.Object
import Magic.Engine.Types.Color 
import Magic.Engine.Types.Mana
import Magic.Engine.Types.CardType
import Magic.Engine.Types.Ability


import Magic.Engine.Types.Effect.TapObjectEffect
import Magic.Engine.Types.Effect.GainManaEffect

import qualified Data.EnumSet as ES
import qualified Data.EnumMultiSet as EMS

import Optics

simplePlay :: Activation
simplePlay = emptyActivation
                & prereq .~ [(SorcTime, OnHand)]

simpleLandPlay :: Activation
simpleLandPlay = emptyActivation 
                & prereq .~ [(LandTime, OnHand)]

simpleTapAbility :: Ability
simpleTapAbility = emptyAbility
                & abilityTypes %~ ES.insert ActivatedAbility
                & activation % prereq .~ [(InstTime, OnField)]
                & activation % costs % otherCosts ?~ tapSelfEffect

manaTapAbility :: Ability
manaTapAbility = simpleTapAbility
                & abilityTypes %~ ES.insert ManaAbility
                & activation % prereq .~ [(InstTime, OnField)]

basicLand :: Mana -> Card
basicLand m = case m of
    ColorlessMana       -> basicLand' m "Wastes"
    (ColoredMana White) -> basicLand' m "Plains"
    (ColoredMana Blue)  -> basicLand' m "Island"
    (ColoredMana Black) -> basicLand' m "Swamp"
    (ColoredMana Red)   -> basicLand' m "Mountain"
    (ColoredMana Green) -> basicLand' m "Forest"
    where 
        basicLand' m n p = emptyCard p 
                            & name .~ n
                            & types % superTypes %~ ES.insert Basic
                            & types % cardTypes %~ ES.insert Land
                            & playAbility ?~ simpleLandPlay
                            & activatedAbilities .~ [manatap m]
        manatap m = manaTapAbility
                        & activation % effects .~ gainManaSelf (EMS.singleton m)

basicCreature :: ManaCost -> PowerToughness -> Card
basicCreature m pt p = emptyCard p 
                        & types % cardTypes %~ ES.insert Creature
                        & powerToughness .~ pt
                        & playAbility ?~ simplePlay
                        & playAbility %? costs % manaCost .~ m


wastes, plains, island, swamp, mountain, forest :: Card
wastes   = basicLand ColorlessMana
plains   = basicLand (ColoredMana White)
island   = basicLand (ColoredMana Blue)
swamp    = basicLand (ColoredMana Black)
mountain = basicLand (ColoredMana Red)
forest   = basicLand (ColoredMana Green)

testWarrior :: Card
testWarrior = basicCreature (EMS.insertMany GenericManaCost 2 EMS.empty) (10,1)
