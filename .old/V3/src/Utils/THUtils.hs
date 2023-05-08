module Utils.THUtils where

import Optics.TH
import Optics.Label
import Language.Haskell.TH.Syntax

baseClassyRule :: ClassyNamer
baseClassyRule n 
            | take 4 name == "Base" = Just (mkName (drop 4 name), mkName ("base"++name))
            | otherwise             = Nothing
                where name = nameBase n