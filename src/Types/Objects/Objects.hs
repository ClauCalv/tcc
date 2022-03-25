{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    DataKinds,                    -- Defining new kinds
    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs                         -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    --MultiParamTypeClasses,      -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    --FlexibleInstances,          -- Implementing complex classes' instances (like Algebra)
    --UndecidableInstances,       -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    --TypeOperators,              -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Types.Objects.Objects where

import Optics

import qualified Data.Dict as D

import Types.Players
import Types.Colors
import Types.Zones.Zone
import Types.Costs.ManaCosts
import Types.Cards.CardTypes

type PlayerRef = D.RefOf Player

newtype PowerToughness = PT (Int, Int)

-- following *CR 109.3*
-- data ObjectType = StackItem' | CardObject' | CardCopy' | Token' |
--     Spell' | Permanent' | Emblem'

-- data Object :: ObjectType -> * where
--     MkStackItem :: StackItem -> Object StackItem'
--     MkCardObject :: CardObject -> Object CardObject'
--     MkCardCopy :: CardCopy -> Object CardCopy'
--     MkToken :: Token -> Object Token'
--     MkSpell :: Spell -> Object Spell'
--     MkPermanent :: Permanent -> Object Permanent'
--     MkEmblem :: Emblem -> Object Emblem'
    
data BaseObject = BaseObject {

    -- following *CR109.3*
    _name :: String,
    _manaCost :: ManaCost,
    _color :: ColorSet,
    --_colorIndicator :: ColorSet,       -- irrelevant?
    _cardType :: CardTypeSet
    --_rulesText :: [String]             --not sure why to implement yet
    --_abilities :: [Ability]            --not sure how to implement yet
    _powerToughness :: Maybe PowerToughness
    _loyalty :: Maybe Int                
    --_handModifier :: Int               -- wont implement, it's only for vanguard games
    --_lifeModifier :: Int               -- wont implement, it's only for vanguard games

    -- following *CR 108.3-4, 109.4*
    _owner :: PlayerRef,
    _controller :: Maybe PlayerRef,

    -- following ?
    _associatedCard :: Maybe Card
}

class IsObject a where
    name :: Is k A_Getter => Optics' k NoIx a String
    manaCost :: Is k A_Getter => Optics' k NoIx a ManaCost