{-# LANGUAGE
    DisambiguateRecordFields        -- Not specifying fully qualified name of field
#-}

module Types.Objects.Permanent.Test where

import Optics
import Types.Objects.Permanent
import qualified Types.Objects.Permanent.Entity

newPermanentStatus :: PermanentStatus
newPermanentStatus = PermanentStatus { 
                        _tapStatus = Untapped,
                        _flipStatus = Flipped,
                        _faceStatus = FaceUp,
                        _phaseStatus = PhasedIn
                    }

printPermanentTapStatus :: HasPermanentStatus a => a -> String
printPermanentTapStatus obj = "TapStatus is " ++ show (view tapStatus obj) ++ "!"

foo :: TapStatus
foo = view tapStatus newPermanentStatus
