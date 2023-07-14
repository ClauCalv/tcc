module Magic.Engine.Types.Effect.GainManaEffect where

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

data GainManaEffect = GainManaEffect {
        targetPlayer :: PlayerRef,
        manaGainAmount :: ManaPool
    }

instance Effect GainManaEffect where
    data EventHistory GainManaEffect = ManaGained {
        targetPlayer :: PlayerRef,
        manaGainAmount :: ManaPool
    }
    runEffect (GainManaEffect p m) = do
        modifying (players % ix p % manaPool) (<> m)
        return $ ManaGained p m

gainManaSelf :: ManaPool -> EffectActivation
tapSelfEffect m actCtx = return [GainManaEffect (fromJust $ actCtx ^. activator) m]