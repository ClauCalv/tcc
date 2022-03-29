{-# LANGUAGE
    DisambiguateRecordFields        -- Not specifying fully qualified name of field
#-}

module Types.Objects.BaseObject.Test where

import Optics
import Types.Objects.Object
import qualified Types.Objects.Object.Entity

import qualified Data.Dict as D
import Types.Players
import Types.Colors
import Types.Zones.Zone
import Types.Costs.ManaCosts
import Types.Cards.CardTypes
import Types.Cards.Card

newBaseObject :: BaseObject
newBaseObject = BaseObject { 
                    _name            = "TEST",
                    _manaCost        = EmptyCost,
                    _color           = colorlessCS,
                    _cardType        = emptyCTS,
                    _powerToughness  = Nothing,
                    _loyalty         = Nothing,                
                    _owner           = D.Ref 0,
                    _controller      = Nothing,
                    _associatedCard  = Nothing
               }

printBaseObjectName :: HasBaseObject a => a -> String
printBaseObjectName obj = "Hello " ++ view name obj ++ "!"

foo :: Maybe Int
foo = view loyalty newBaseObject
