
module Types.Objects.Object (
    Entity.BaseObject(BaseObject),
    Entity.PowerToughness,
    Entity.PlayerRef,

    module Class,
    module Lenses,
) where

import qualified Types.Objects.Object.Class as Class
import qualified Types.Objects.Object.Entity as Entity
import qualified Types.Objects.Object.Lenses as Lenses

-- following *CR 109.3*
-- data ObjectType = StackAbility' | CardObject' | CardCopy' | Token' |
--     Spell' | Permanent' | Emblem'

-- data Object :: ObjectType -> * where
--     MkStackAbility :: StackAbility -> Object StackAbility'
--     MkCardObject :: CardObject -> Object CardObject'
--     MkCardCopy :: CardCopy -> Object CardCopy'
--     MkToken :: Token -> Object Token'
--     MkSpell :: Spell -> Object Spell'
--     MkPermanent :: Permanent -> Object Permanent'
--     MkEmblem :: Emblem -> Object Emblem'