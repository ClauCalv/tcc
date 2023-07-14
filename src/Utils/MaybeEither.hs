module Utils.MaybeEither where
import Control.Monad.Extra (whenMaybe, when)
import Data.Maybe (isJust, fromJust)


maybeToEither :: a -> Maybe b -> Either a b
maybeToEither _ (Just x) = Right x
maybeToEither y Nothing  = Left y

eitherToMaybe :: Either a b -> Maybe b
eitherToMaybe (Left y)  = Nothing
eitherToMaybe (Right x) = Just x

tryApply :: (a -> Maybe b) -> a -> Either a b
tryApply f x = maybeToEither x (f x)

loopMaybe :: Monad m => m (Maybe b) -> m b
loopMaybe f = do
    fx <- f
    case fx of
        Nothing -> loopMaybe f
        Just b -> return b

loopEither :: Monad m => (a -> m (Either a b)) -> a -> m b
loopEither f x = do
    fx <- f x
    case fx of
        Left x' -> loopEither f x'
        Right b -> return b 

mapLeft :: (b -> c) -> Either b a -> Either c a
mapLeft f (Left x) = Left (f x)
mapLeft _ (Right x) = Right x