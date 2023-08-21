{-# LANGUAGE DuplicateRecordFields, DataKinds, TypeFamilies #-}
module Magic.Engine.Types.Effect.TapObjectEffect where

import Magic.Engine.Types.Effect
import Magic.Engine.Types.Ability
import Magic.Engine.Types.World
import Magic.Engine.Types.Zone
import Magic.Engine.Types.Object

import Control.Effect.Optics
import Optics hiding (modifying, modifying', assign, assign', use, preuse) -- Hide Optics.State entirely!

import qualified Magic.Data.Dict as D
import Data.Maybe (fromJust)
import Magic.Engine.Types.Zone (ZoneRef(ixZoneObj))

data TapObjectEffect = TapObjectEffect {
    _targetObjRef :: ObjectZoneRef BattlefieldZRef
}

data PermanentTappedEvent = PermanentTappedEvent {
    _targetObjRef :: ObjectZoneRef BattlefieldZRef
}

instance Effect TapObjectEffect where
    data EventHistory TapObjectEffect = PermanentTapped {
        targetObjRef :: ObjectZoneRef PermanentObjTp
    }
    runEffect (TapObjectEffect objZoneRef) = do
        assign (zones % ixZoneObj objZoneRef % permanent % permanentStatus % tapStatus) Tapped
        return $ PermanentTapped objZoneRef

tapSelfEffect :: EffectActivation
tapSelfEffect actCtx = return [MkWrap . TapObjectEffect . fromJust $ actCtx ^. source]