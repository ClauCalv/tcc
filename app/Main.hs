module Main where

--import V1.Lib
--import V2.Server

import RemoteGame
import LocalGame

-- Main

data ServerType = Local | Remote

startGame :: ServerType -> IO ()
startGame Local = startLocalGame
startGame Remote = startRemoteGame

main :: IO ()
main = startGame Local
