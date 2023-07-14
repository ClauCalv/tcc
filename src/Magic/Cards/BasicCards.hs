module Magic.Cards.BasicCards where

import Magic.Engine.Types.Player
import Magic.Engine.Types.Object
import Magic.Engine.Types.Color 
import Magic.Engine.Types.Mana
import Magic.Engine.Types.CardType

import Magic.Engine.Types.Effect.TapObjectEffect
import Magic.Engine.Types.Effect.GainManaEffect

import qualified Data.EnumSet as ES
import qualified Data.EnumMultiSet as EMS

simplePlay :: Activation
simplePlay = emptyActivation
                & prereq .~ [(SorcTime, OnHand)]

simpleLandPlay :: Activation
simplePlay = emptyActivation 
                & prereq .~ [(LandTime, OnHand)]

simpleTapAbility :: Ability
simpleTapAbility = emptyAbility
                & abilityTypes %~ ES.insert ActivatedAbility
                & activation % prereq .~ [(InstTime, OnField)]
                & activation % costs % othercosts ?= tapSelfEffect

manaTapAbility :: Ability
manaTapAbility = simpleTapAbility
                & abilityTypes %~ ES.insert ManaAbility
                & activation % prereq .~ [(InstTime, OnField)]

basicLand :: Mana -> Card
basicLand ColorlessMana = basicLand' ColorlessMana "Wastes"
basicLand (ColoredMana W) = basicLand' (ColoredMana W) "Plains"
basicLand (ColoredMana U) = basicLand' (ColoredMana U) "Island"
basicLand (ColoredMana B) = basicLand' (ColoredMana B) "Swamp"
basicLand (ColoredMana R) = basicLand' (ColoredMana R) "Mountain"
basicLand (ColoredMana G) = basicLand' (ColoredMana G) "Forest"
    where 
        basicLand' m n p = emptyCard p 
                            & name .~ n
                            & types % superTypes %~ ES.insert Basic
                            & types % cardTypes %~ ES.insert Land
                            & playAbility ?~ simpleLandPlay
                            & _activatedAbilities .~ manatap m
        manatap m = manaTapAbility
                        & activation % effects .~ gainManaSelf m

basicCreature :: ManaCost -> PowerToughness -> Card
basicCreature m pt p = emptyCard p 
                        & types % cardTypes %~ ES.insert Creature
                        & powerToughness .~ pt
                        & playAbility ?~ simplePlay
                        & playAbility %? activation % costs % manaCost .~ m


wastes, plains, island, swamp, mountain, forest :: Card
wastes   = basicLand ColorlessMana
plains   = basicLand (ColoredMana W)
island   = basicLand (ColoredMana U)
swamp    = basicLand (ColoredMana B)
mountain = basicLand (ColoredMana R)
forest   = basicLand (ColoredMana G)

testWarrior :: Card
testWarrior = basicCreature (EMS.insertMany 2 GenericManaCost EMS.empty) (10,1)
