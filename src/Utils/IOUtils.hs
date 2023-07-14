{-# LANGUAGE 
    TypeApplications          -- Defining type in expression via @
#-}

module Utils.IOUtils where

import Control.Monad.IO.Class
import Text.Read (readMaybe)
import Data.Maybe
import Optics

getInputLoopWithMessage :: (Read a, MonadIO m) => String -> (a -> Maybe b) -> m b
getInputLoopWithMessage m f = getInputLoopWithMessage' m readMaybe f

getInputLoopWithMessage' :: MonadIO m => String -> (String -> Maybe a) -> (a -> Maybe b) -> m b
getInputLoopWithMessage' m format validate = do
  liftIO $ putStrLn m
  input <- liftIO $ getLine
  let output = format input >>= validate
  if isJust output then return (fromJust output) else getInputLoopWithMessage' m format validate

assert :: (a -> Bool) -> a -> Maybe a
assert f a = if f a then Just a else Nothing

assertMany :: [(a -> Bool)] -> a -> Maybe a
assertMany fs a = if all id (map ($ a) fs) then Just a else Nothing

readGetLine :: (Read a) => IO a
readGetLine = getLine >>= return . read