module Types.Colors where

import qualified Data.EnumSet as ES

data Color = White | Blue | Black | Red | Green
    deriving (Eq, Ord, Bounded, Enum, Show, Read)

type ColorSet = ES.EnumSet Color

whiteCS :: ColorSet
whiteCS = ES.singleton White

blueCS :: ColorSet
blueCS = ES.singleton Blue

blackCS :: ColorSet
blackCS = ES.singleton Black

redCS :: ColorSet
redCS = ES.singleton Red

greenCS :: ColorSet
greenCS = ES.singleton Green

colorlessCS :: ColorSet
colorlessCS = ES.empty

allColorsCS :: ColorSet
allColorsCS = ES.insert White $
              ES.insert Blue $
              ES.insert Black $
              ES.insert Red $
              ES.insert Green $
              ES.empty
              