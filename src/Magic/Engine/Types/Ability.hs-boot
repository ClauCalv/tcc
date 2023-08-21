module Magic.Engine.Types.Ability where

import {-# SOURCE #-} Magic.Engine.MagicGame.Contextual
import {-# SOURCE #-} Magic.Engine.Types.Effect

import Data.Class.Wrap (Wrap)


type EffectActivation = ActivationContext -> Contextual [Wrap Effect]

data Ability

data ActivationContext 

data Activation

data Costs