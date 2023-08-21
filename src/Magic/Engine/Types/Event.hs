{-# LANGUAGE TypeFamilies #-}

module Magic.Engine.Types.Event where

import {-# SOURCE #-} Magic.Engine.Types.World
import Magic.Engine.MagicGame

import Control.Algebra
import Control.Effect.State
import Optics

class Show ev => Event ev where
    undo :: (Has (State MagicWorld) sig m, Has MagicGame sig m) => ev -> m ()

instance Event ev => Wrap Event where
    undo (MkWrap ev) = undo ev