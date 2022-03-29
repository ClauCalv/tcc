module Types.Objects.Permanent where

import Data.Class.Cycle

import Types.Objects.BaseObject

data Permanent = Permanent {
    baseObject :: BaseObject,
    permanentStatus :: PermanentStatus
}

data PermanentStatus = PermanentStatus {
    tapStatus :: TapStatus,
    flipStatus :: FlipStatus,
    faceStatus :: FaceStatus,
    phaseStatus :: PhaseStatus
} deriving (Eq, Show, Read)

data TapStatus =  Untapped | Tapped
    deriving (Eq, Ord, Enum, Bounded, Show, Read)
data FlipStatus = Unflipped | Flipped
    deriving (Eq, Ord, Enum, Bounded, Show, Read)
data FaceStatus =  FaceUp | FaceDown
    deriving (Eq, Ord, Enum, Bounded, Show, Read)
data PhaseStatus = PhasedIn | PhasedOut
    deriving (Eq, Ord, Enum, Bounded, Show, Read)

instance Cycle TapStatus
instance Cycle FlipStatus
instance Cycle FaceStatus
instance Cycle PhaseStatus

defaultPermanentStatus :: PermanentStatus
defaultPermanentStatus = PermanentStatus Untapped Unflipped FaceUp PhasedIn