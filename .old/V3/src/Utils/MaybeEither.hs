module Utils.MaybeEither where


maybeToEither :: a -> Maybe b -> Either a b
maybeToEither _ (Just x) = Right x
maybeToEither y Nothing  = Left y

eitherToMaybe :: Either a b -> Maybe b
eitherToMaybe (Left y)  = Nothing
eitherToMaybe (Right x) = Just x

tryApply :: (a -> Maybe b) -> a -> Either a b
tryApply f x = maybeToEither x (f x)