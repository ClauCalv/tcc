module Magic.Engine.Types.Effect.TapObjectEffect where

import Magic.Engine.Types.Zone
import Magic.Engine.Types.Object
import Control.Carrier.State.Church (State, modify)
import Control.Monad (when)
import Data.Maybe (isJust)
import Types.World (World(_zones))
import qualified Data.Dict as D
import Control.Effect.Optics (assign)
import Optics (At(at))
import Data.Bool (Bool(True))

data TapObjectEffect = TapObjectEffect {
    targetObjRef :: ObjectZoneRef PermanentObjTp
}

instance Effect TapObjectEffect where
    data EventHistory TapObjectEffect = PermanentTapped {
        targetObjRef :: ObjectZoneRef PermanentObjTp
    }
    runEffect (TapObjectEffect objZoneRef) = do
        assign (zones % ix (objZoneRef ^. zoneRef) % ix (objZoneRef ^. objRef) % permanentObject % tapStatus) Tapped
        return $ PermanentTapped objZoneRef

tapSelfEffect :: EffectActivation
tapSelfEffect actCtx = return [TapObjectEffect . fromJust $ actCtx ^. source]