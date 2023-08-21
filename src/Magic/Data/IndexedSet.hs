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

module Magic.Data.IndexedSet where

import qualified Data.IntMap.Strict as IM
import Magic.Data.Empty
import Optics
import Utils.MaybeEither (maybeToEither)

import Prelude hiding (lookup)

data IndexedSet k a where -- K does nothing for now, just tags key. May be useful later
    IndexedSet :: {-- (k ~ Int) => --} IM.IntMap a -> IndexedSet k a

instance Empty (IndexedSet k a) where
    empty = IndexedSet IM.empty

type instance Index (IndexedSet k a) = Int
type instance IxValue (IndexedSet k a) = a
instance Ixed (IndexedSet k a) where
    type IxKind (IndexedSet k a) = An_AffineTraversal
    ix :: Int -> AffineTraversal' (IndexedSet k a) a
    ix k = atraversal (\is -> maybeToEither is $ lookup k is) (\is v -> adjust (const v) k is)
instance At (IndexedSet k a) where
    at :: Int -> Lens' (IndexedSet k a) (Maybe a)
    at k = lensVL $ \is f -> alterF is k f 

wrap :: IM.IntMap a -> IndexedSet k a
wrap = IndexedSet

unwrap :: IndexedSet k a -> IM.IntMap a
unwrap (IndexedSet im) = im

insert :: Int -> a -> IndexedSet k a -> IndexedSet k a
insert k v = wrap . IM.insert k v . unwrap

insertMany :: [(Int, a)] -> IndexedSet k a -> IndexedSet k a
insertMany ks = wrap . (IM.fromList ks `IM.union`) . unwrap

adjust :: (a -> a) -> Int -> IndexedSet k a -> IndexedSet k a
adjust f k = wrap . IM.adjust f k . unwrap

alterF :: Functor f => (Maybe a -> f (Maybe a)) -> Int -> IndexedSet k a -> f (IndexedSet k a)
alterF f k (IndexedSet im) = fmap wrap (IM.alterF f k im)

lookup :: Int -> IndexedSet k a -> Maybe a
lookup k = IM.lookup k . unwrap

map :: (a -> b) -> IndexedSet k a -> IndexedSet k b
map f = wrap . IM.map f . unwrap

filter :: (a -> Bool) -> IndexedSet k a -> IndexedSet k a
filter f = wrap . IM.filter f . unwrap

fromList :: [(Int, a)] -> IndexedSet k a
fromList = wrap . IM.fromList