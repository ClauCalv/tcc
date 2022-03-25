module Types.Zones (
    module Types.Zones.Zone,
    module Types.Zones.SimpleZone,
    module Types.Zones.OrderedZone
) where

import Types.Zones.Zone
import Types.Zones.SimpleZone
import Types.Zones.OrderedZone

data Zones = Zones
    { _exile        :: D.Dict (EntityOfType TyCard)
    , _battlefield  :: D.Dict (EntityOfType TyPermanent)
    , _stack        :: D.Dict (EntityOfType TyStackItem)
    , _command      :: D.Dict (EntityOfType TyCard)
    , _library      :: D.Dict (D.RefOf Player, D.Dict (EntityOfType TyCard))
    , _hand         :: D.Dict (D.RefOf Player, D.Dict (EntityOfType TyCard))
    , _graveyard    :: D.Dict (D.RefOf Player, D.Dict (EntityOfType TyCard))
    }