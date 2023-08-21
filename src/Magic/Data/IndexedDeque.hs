{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    TypeFamilies                  -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Magic.Data.IndexedDeque where

import qualified Data.IntMap.Strict as IM
import qualified Data.Sequence as Seq
import Data.Sequence.Optics

import System.Random

import Magic.Data.Empty
import Optics
import Utils.MaybeEither (maybeToEither)

import Prelude hiding (lookup)
import Data.Function (on)

data IndexedDeque k a where
    IndexedDeque :: (Seq.Seq Int) -> (IM.IntMap a) -> IndexedDeque k a

instance Empty (IndexedDeque k a) where
    empty = IndexedDeque Seq.empty IM.empty

atTop, atBottom :: Lens' (IndexedDeque k a) (Maybe a)
atTop = lensVL alterTopF
atBottom = lensVL alterBottomF

type instance Index (IndexedDeque k a) = Int
type instance IxValue (IndexedDeque k a) = a
instance Ixed (IndexedDeque k a) where
    type IxKind (IndexedDeque k a) = An_AffineTraversal
    ix :: Int -> AffineTraversal' (IndexedDeque k a) a
    ix k = atraversal (\idq -> maybeToEither idq $ lookup k idq) (\is v -> adjust (const v) k is)
--instance At (IndexedDeque a) where
--    at :: Int -> Lens' (IndexedDeque a) (Maybe a)
--    at k = lensVL $ \is f -> alterF is k f


insertTop :: a -> IndexedDeque k a -> IndexedDeque k a
insertTop v (IndexedDeque Seq.Empty _) = IndexedDeque (Seq.singleton 0) (IM.singleton 0 v)
insertTop v (IndexedDeque seq im) = IndexedDeque (newKey Seq.:<| seq) (IM.insert newKey v im)
    where newKey = succ . fst . IM.findMax $ im

insertBottom :: a -> IndexedDeque k a -> IndexedDeque k a
insertBottom v (IndexedDeque Seq.Empty _) = IndexedDeque (Seq.singleton 0) (IM.singleton 0 v)
insertBottom v (IndexedDeque seq im) = IndexedDeque (seq Seq.:|> newKey) (IM.insert newKey v im)
    where newKey = succ . fst . IM.findMax $ im

insertManyTop :: [a] -> IndexedDeque k a -> IndexedDeque k a
insertManyTop vs idq = foldl (flip insertTop) idq vs

insertManyBottom :: [a] -> IndexedDeque k a -> IndexedDeque k a
insertManyBottom vs idq = foldl (flip insertBottom) idq vs

adjust :: (a -> a) -> Int -> IndexedDeque k a -> IndexedDeque k a
adjust f k (IndexedDeque seq im) = IndexedDeque seq $ IM.adjust f k im

adjustTop :: (a -> a) -> IndexedDeque k a -> IndexedDeque k a
adjustTop f (IndexedDeque Seq.Empty im) = IndexedDeque Seq.Empty im
adjustTop f (IndexedDeque (k Seq.:<| seq) im) = IndexedDeque (k Seq.:<| seq) $ IM.adjust f k im

adjustBottom :: (a -> a) -> IndexedDeque k a -> IndexedDeque k a
adjustBottom f (IndexedDeque Seq.Empty im) = IndexedDeque Seq.Empty im
adjustBottom f (IndexedDeque (seq Seq.:|> k) im) = IndexedDeque (seq Seq.:|> k) $ IM.adjust f k im

alterTopF :: Functor f => (Maybe a -> f (Maybe a)) -> IndexedDeque k a -> f (IndexedDeque k a)
alterTopF f idq@(IndexedDeque Seq.Empty im) = (<$> f Nothing) $ \x -> case x of
    Nothing -> idq
    Just v -> insertTop v idq
alterTopF f idq@(IndexedDeque (k Seq.:<| seq) im) = (<$> f (IM.lookup k im)) $ \x -> case x of
    Nothing -> removeTop idq
    Just v -> adjustTop (const v) idq

alterBottomF :: Functor f => (Maybe a -> f (Maybe a)) -> IndexedDeque k a -> f (IndexedDeque k a)
alterBottomF f idq@(IndexedDeque Seq.Empty im) = (<$> f Nothing) $ \x -> case x of
    Nothing -> idq
    Just v -> insertBottom v idq
alterBottomF f idq@(IndexedDeque (seq Seq.:|> k) im) = (<$> f (IM.lookup k im)) $ \x -> case x of
    Nothing -> removeBottom idq
    Just v -> adjustBottom (const v) idq

lookup :: Int -> IndexedDeque k a -> Maybe a
lookup k (IndexedDeque seq im) = Seq.lookup k seq >>= (`IM.lookup` im)

lookupTop :: IndexedDeque k a -> Maybe a
lookupTop (IndexedDeque Seq.Empty im) = Nothing
lookupTop (IndexedDeque (k Seq.:<| seq) im) = IM.lookup k im

lookupBottom :: IndexedDeque k a -> Maybe a
lookupBottom (IndexedDeque Seq.Empty im) = Nothing
lookupBottom (IndexedDeque (seq Seq.:|> k) im) = IM.lookup k im

remove :: Int -> IndexedDeque k a -> IndexedDeque k a
remove k (IndexedDeque seq im) = case k' of
    Nothing -> IndexedDeque seq im
    Just v -> IndexedDeque (Seq.deleteAt k seq) (IM.delete v im)
    where
        k' = Seq.lookup k seq

removeTop :: IndexedDeque k a -> IndexedDeque k a
removeTop (IndexedDeque Seq.Empty im) = IndexedDeque Seq.Empty im
removeTop (IndexedDeque (k Seq.:<| seq) im) = IndexedDeque seq $ IM.delete k im

removeBottom :: IndexedDeque k a -> IndexedDeque k a
removeBottom (IndexedDeque Seq.Empty im) = IndexedDeque Seq.Empty im
removeBottom (IndexedDeque (seq Seq.:|> k) im) = IndexedDeque seq $ IM.delete k im

map :: (a -> b) -> IndexedDeque k a -> IndexedDeque k b
map f (IndexedDeque seq im) = IndexedDeque seq $ IM.map f im

filter :: (a -> Bool) -> IndexedDeque k a -> IndexedDeque k a
filter f (IndexedDeque seq im) = IndexedDeque seq' im'
    where
        im' = IM.filter f im
        seq' = Seq.filter (\k -> k `elem` IM.keys im') seq

randomShuffle :: RandomGen g => g -> IndexedDeque k a -> IndexedDeque k a
randomShuffle g (IndexedDeque seq im) = IndexedDeque randomSeq im
    where
        randomSeq = fmap fst . Seq.unstableSortBy (compare `on` snd) $ Seq.zip seq (Seq.fromList . take (Seq.length seq) $ randoms @Int g)