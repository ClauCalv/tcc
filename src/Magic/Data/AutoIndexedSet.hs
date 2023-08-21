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

module Magic.Data.AutoIndexedSet where

import qualified Data.IntMap.Strict as IM
import Magic.Data.Empty
import Optics
import Utils.MaybeEither (maybeToEither)

import Prelude hiding (lookup)

data AutoIndexedSet k a where
    AutoIndexedSet :: Int -> (IM.IntMap a) -> AutoIndexedSet k a

instance Empty (AutoIndexedSet k a) where
    empty = AutoIndexedSet 0 IM.empty

type instance Index (AutoIndexedSet k a) = Int
type instance IxValue (AutoIndexedSet k a) = a
instance Ixed (AutoIndexedSet k a) where
    type IxKind (AutoIndexedSet k a) = An_AffineTraversal
    ix :: Int -> AffineTraversal' (AutoIndexedSet k a) a
    ix k = atraversal (\is -> maybeToEither is $ lookup k is) (\is v -> adjust (const v) k is)
--AutoIndexedSet CANT USE AT
--instance At (IndexedSet a) where
--    at :: Int -> Lens' (IndexedSet a) (Maybe a)
--    at k = lens (lookup k) (\is v -> update (const v) k is)


insert :: a -> AutoIndexedSet k a -> AutoIndexedSet k a
insert v (AutoIndexedSet k' im) = AutoIndexedSet (succ k') $ IM.insert k' v im

insertMany :: [a] -> AutoIndexedSet k a -> AutoIndexedSet k a
insertMany vs ais = foldl (flip insert) ais vs

adjust :: (a -> a) -> Int -> AutoIndexedSet k a -> AutoIndexedSet k a
adjust f k (AutoIndexedSet k' im) = AutoIndexedSet k' $ IM.adjust f k im

alterF :: Functor f => (Maybe a -> f (Maybe a)) -> Int -> AutoIndexedSet k a -> f (AutoIndexedSet k a)
alterF f k (AutoIndexedSet k' im) = fmap (AutoIndexedSet k') (IM.alterF f k im)

lookup :: Int -> AutoIndexedSet k a -> Maybe a
lookup k (AutoIndexedSet k' im) = IM.lookup k im

map :: (a -> b) -> AutoIndexedSet k a -> AutoIndexedSet k b
map f (AutoIndexedSet k' im) = AutoIndexedSet k' $ IM.map f im

filter :: (a -> Bool) -> AutoIndexedSet k a -> AutoIndexedSet k a
filter f (AutoIndexedSet k' im) = AutoIndexedSet k' $ IM.filter f im