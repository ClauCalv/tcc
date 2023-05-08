
module Types.Objects.Object (
    Entity.BaseObject(BaseObject),
    Entity.PowerToughness,
    Entity.PlayerRef,

    module Class,
    module Lenses,
) where

import Types.Objects.Object.Class as Class
import Types.Objects.Object.Entity as Entity
import Types.Objects.Object.Lenses as Lenses