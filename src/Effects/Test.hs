{-# LANGUAGE 
    UndecidableInstances, GADTs
 #-}

module Effects.Test where

import Control.Algebra
import Control.Carrier.Trace.Printing
import Control.Carrier.State.Strict
import Control.Carrier.Lift
import Control.Monad.IO.Class

-- Lets build an example that just uses a combination of
-- We will need Trace, State, and the one we will write

---- Example structs
data AccumulatorAB = AccumulatorAB { fieldA :: Int, fieldB :: Int } deriving (Eq, Show)
data AccumulatorField = A | B

emptyAccumulatorAB :: AccumulatorAB
emptyAccumulatorAB = AccumulatorAB 0 0

---- Example Effect
data AccumulatorEffect (m :: * -> *) k where
    IncrementPrintGet :: AccumulatorField -> AccumulatorEffect m Int
    GetCurrent :: AccumulatorEffect m AccumulatorAB

incrementPrintGet :: Has AccumulatorEffect sig m => AccumulatorField -> m Int
incrementPrintGet = send . IncrementPrintGet

getCurrent :: Has AccumulatorEffect sig m => m AccumulatorAB
getCurrent = send GetCurrent

---- Example Carrier
type AccumulatorCarrierConstraints sig m = (MonadIO m, Has Trace sig m, Has (State AccumulatorAB) sig m, Algebra sig m )

newtype AccumulatorCarrier m a = AccumulatorCarrier { runAccumulatorCarrier :: m a }
    deriving (Applicative, Functor, Monad, MonadIO)

instance AccumulatorCarrierConstraints sig m => Algebra (AccumulatorEffect :+: sig) (AccumulatorCarrier m) where
  alg hdl sig ctx = case sig of
    L (IncrementPrintGet c) -> (<$ ctx) <$> internalIncrementPrintGet c
    L (GetCurrent) -> (<$ ctx) <$> internalGetCurrent
    R other -> AccumulatorCarrier (alg (runAccumulatorCarrier . hdl) other ctx)

internalIncrementPrintGet :: AccumulatorCarrierConstraints sig m => AccumulatorField -> m Int
internalIncrementPrintGet A = do
    a <- gets fieldA
    trace $ "A : " ++ show a
    modify $ \acc -> acc{fieldA = a + 1}
    gets fieldA
internalIncrementPrintGet B = do
    b <- gets fieldB
    trace $ "B : " ++ show b
    modify $ \acc -> acc{fieldB = b + 1}
    gets fieldB

internalGetCurrent :: AccumulatorCarrierConstraints sig m => m AccumulatorAB
internalGetCurrent = get

-- Now lets show the problem:

---- Generic function that expects the effects:
foo :: Has AccumulatorEffect sig m => m AccumulatorAB
foo = do incrementPrintGet A; incrementPrintGet B; incrementPrintGet A; getCurrent
---- foo should just return { fieldA = 2, fieldB = 1}

---- This works, but is not flexible:
runAccumulatorWithPredefinedFunction :: IO AccumulatorAB
runAccumulatorWithPredefinedFunction = runM . runTrace . evalState emptyAccumulatorAB . runAccumulatorCarrier $ foo

---- This is what we want to achieve, but I cannot make it work:
{-
runAccumulatorWithFunctionAsArgument :: Has AccumulatorEffect sig m => m a -> IO a
runAccumulatorWithFunctionAsArgument = runM . runTrace . evalState emptyAccumulatorAB . runAccumulatorCarrier

main :: IO ()
main = do
    fooResult <- runAccumulatorWithFunctionAsArgument foo 
    print (fooResult == AccumulatorAB 2 1)
-}