{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    -- KindSignatures,            -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs                         -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    --MultiParamTypeClasses,        -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    --FlexibleInstances,            -- Implementing complex classes' instances (like Algebra)
    --UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    --TypeOperators,                -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    --GeneralizedNewtypeDeriving    -- Code shortening, unnecessary but useful.
#-}

module Data.EnumMultiSet where

import Prelude hiding (map)

import qualified Data.List as L

import qualified Data.IntSet as IS
import qualified Data.EnumSet as ES

import qualified Data.IntMap as IM
import qualified Data.EnumMap as EM

import qualified Data.MultiSet as MS
import qualified Data.IntMultiSet as IMS

newtype EnumMultiSet a = EMS { unEMS :: IMS.IntMultiSet }


-- Conversion to/from 'IntMultiSet'.

intMStoEnumMS :: IMS.IntMultiSet -> EnumMultiSet k
intMStoEnumMS = EMS
{-# INLINE intMStoEnumMS #-}

enumMStoIntMS :: EnumMultiSet k -> IMS.IntMultiSet
enumMStoIntMS = unEMS
{-# INLINE enumMStoIntMS #-}

{--------------------------------------------------------------------
  Query
--------------------------------------------------------------------}

null :: EnumMultiSet a -> Bool
null = IMS.null . unEMS

size :: EnumMultiSet a -> Int
size = IMS.size . unEMS 

distinctSize :: EnumMultiSet a -> Int
distinctSize = IMS.size . unEMS

member :: (Enum a) => a -> EnumMultiSet a -> Bool
member x = IMS.member (fromEnum x) . unEMS

notMember :: (Enum a) => a -> EnumMultiSet a -> Bool
notMember x = not . member x

occur :: (Enum a) => a -> EnumMultiSet a -> Int
occur x = IMS.occur (fromEnum x) . unEMS

{--------------------------------------------------------------------
  Construction
--------------------------------------------------------------------}

empty :: EnumMultiSet a
empty = EMS IMS.empty

singleton :: (Enum a) => a -> EnumMultiSet a
singleton x = EMS (IMS.singleton (fromEnum x))

{--------------------------------------------------------------------
  Insertion, Deletion
--------------------------------------------------------------------}

insert :: (Enum a) => a -> EnumMultiSet a -> EnumMultiSet a
insert x = EMS . IMS.insert (fromEnum x) . unEMS

-- Negative numbers remove occurrences of the given element.
insertMany :: (Enum a) => a -> Int -> EnumMultiSet a -> EnumMultiSet a
insertMany x n = EMS . IMS.insertMany (fromEnum x) n . unEMS

delete :: (Enum a) => a -> EnumMultiSet a -> EnumMultiSet a
delete x = EMS . IMS.delete (fromEnum x) . unEMS

-- Negative numbers add occurrences of the given element.
deleteMany :: (Enum a) => a -> Int -> EnumMultiSet a -> EnumMultiSet a
deleteMany x n = insertMany x (negate n)

deleteAll :: (Enum a) => a -> EnumMultiSet a -> EnumMultiSet a
deleteAll x = EMS . IMS.deleteAll (fromEnum x) . unEMS

{--------------------------------------------------------------------
  Subset
--------------------------------------------------------------------}

isProperSubsetOf :: EnumMultiSet a -> EnumMultiSet a -> Bool
isProperSubsetOf (EMS m1) (EMS m2) = IMS.isProperSubsetOf m1 m2

isSubsetOf :: EnumMultiSet a -> EnumMultiSet a -> Bool
isSubsetOf (EMS m1) (EMS m2) = IMS.isSubsetOf m1 m2

{--------------------------------------------------------------------
  Union, Difference, Intersection
--------------------------------------------------------------------}

unions :: [EnumMultiSet a] -> EnumMultiSet a
unions = EMS . IMS.unions . L.map unEMS

-- The union adds the occurrences together.
union :: EnumMultiSet a -> EnumMultiSet a -> EnumMultiSet a
union (EMS m1) (EMS m2) = EMS $ IMS.union m1 m2

-- The number of occurrences of each element in the union is
-- the maximum of the number of occurrences in the arguments (instead of the sum).
maxUnion :: EnumMultiSet a -> EnumMultiSet a -> EnumMultiSet a
maxUnion (EMS m1) (EMS m2) = EMS $ IMS.maxUnion m1 m2

difference :: EnumMultiSet a -> EnumMultiSet a -> EnumMultiSet a
difference (EMS m1) (EMS m2) = EMS $ IMS.difference m1 m2

intersection :: EnumMultiSet a -> EnumMultiSet a -> EnumMultiSet a
intersection (EMS m1) (EMS m2) = EMS $ IMS.intersection m1 m2

{--------------------------------------------------------------------
  Filter and partition
--------------------------------------------------------------------}

filter :: (Enum a) => (a -> Bool) -> EnumMultiSet a -> EnumMultiSet a
filter f = EMS . IMS.filter (\i -> f (toEnum i)) . unEMS

partition :: (Enum a) => (a -> Bool) -> EnumMultiSet a -> (EnumMultiSet a, EnumMultiSet a)
partition f m = let (ims1, ims2) = IMS.partition (\i -> f (toEnum i)) . unEMS $ m
                in (EMS ims1, EMS ims2)

{----------------------------------------------------------------------
  Map
----------------------------------------------------------------------}

map :: (Enum a) => (a -> a) -> EnumMultiSet a -> EnumMultiSet a
map f = EMS . IMS.map (fromEnum . f . toEnum) . unEMS

mapMaybe :: (Enum a) => (a -> Maybe a) -> EnumMultiSet a -> EnumMultiSet a
mapMaybe f = EMS . IMS.mapMaybe (fmap fromEnum . f . toEnum) . unEMS

mapEither :: (Enum a) => (a -> Either a a) -> EnumMultiSet a -> (EnumMultiSet a, EnumMultiSet a)
mapEither f em = let (ims1, ims2) = IMS.mapEither (fromEnumE . f . toEnum) . unEMS $ em
                 in (EMS ims1, EMS ims2)
                 where
                   fromEnumE (Right x) = Right (fromEnum x)
                   fromEnumE (Left x) = Left (fromEnum x)

concatMap :: (Enum a) => (a -> [a]) -> EnumMultiSet a -> EnumMultiSet a
concatMap f = EMS . IMS.concatMap (fmap fromEnum . f . toEnum) . unEMS

unionsMap :: (Enum a) => (a -> EnumMultiSet a) -> EnumMultiSet a -> EnumMultiSet a
unionsMap f = EMS . IMS.unionsMap (unEMS . f . toEnum) . unEMS

join :: MS.MultiSet (EnumMultiSet a) -> EnumMultiSet a
join = EMS . IMS.join . MS.map unEMS

bind :: (Enum a) => EnumMultiSet a -> (a -> EnumMultiSet a) -> EnumMultiSet a
bind = flip unionsMap

{--------------------------------------------------------------------
  Fold
--------------------------------------------------------------------}

fold :: (Enum a) => (a -> b -> b) -> b -> EnumMultiSet a -> b
fold f z = IMS.fold (\i b -> f (toEnum i) b) z . unEMS

foldr :: (Enum a) => (a -> b -> b) -> b -> EnumMultiSet a -> b
foldr f z = fold f z

foldOccur :: (Enum a) => (a -> Int -> b -> b) -> b -> EnumMultiSet a -> b
foldOccur f z = IMS.foldOccur (\i c b -> f (toEnum i) c b) z . unEMS

{--------------------------------------------------------------------
  List variations 
--------------------------------------------------------------------}

elems :: (Enum a) => EnumMultiSet a -> [a]
elems = fmap toEnum . IMS.elems . unEMS

distinctElems :: (Enum a) => EnumMultiSet a -> [a]
distinctElems = fmap toEnum . IMS.distinctElems . unEMS

{--------------------------------------------------------------------
  Lists 
--------------------------------------------------------------------}

toList :: (Enum a) => EnumMultiSet a -> [a]
toList = fmap toEnum . IMS.toList . unEMS

fromList :: (Enum a) => [a] -> EnumMultiSet a
fromList = EMS . IMS.fromList . fmap fromEnum

{--------------------------------------------------------------------
  Occurrence lists 
--------------------------------------------------------------------}

toOccurList :: (Enum a) => EnumMultiSet a -> [(a,Int)]
toOccurList = fmap (\(a, b) -> (toEnum a, b)) . IMS.toOccurList . unEMS

-- Occurrences must be positive.
fromOccurList :: (Enum a) => [(a, Int)] -> EnumMultiSet a
fromOccurList = EMS . IMS.fromOccurList . fmap (\(a, b) -> (fromEnum a, b))

{--------------------------------------------------------------------
  Map
--------------------------------------------------------------------}

toMap :: EnumMultiSet a -> EM.EnumMap a Int
toMap = EM.intMapToEnumMap . toIntMap

fromMap :: EM.EnumMap a Int -> EnumMultiSet a
fromMap = fromIntMap . EM.enumMapToIntMap

toIntMap :: EnumMultiSet a -> IM.IntMap Int
toIntMap = IMS.toMap . unEMS

fromIntMap :: IM.IntMap Int -> EnumMultiSet a
fromIntMap = EMS . IMS.fromMap

{--------------------------------------------------------------------
  Set
--------------------------------------------------------------------}

toSet :: EnumMultiSet a -> ES.EnumSet a
toSet = ES.intSetToEnumSet . toIntSet

-- | /O(n)/. Convert an 'IntMap' to a multiset.
fromSet :: ES.EnumSet a -> EnumMultiSet a
fromSet = fromIntSet . ES.enumSetToIntSet 

toIntSet :: EnumMultiSet a -> IS.IntSet
toIntSet = IMS.toSet . unEMS

-- | /O(n)/. Convert an 'IntMap' to a multiset.
fromIntSet :: IS.IntSet -> EnumMultiSet a
fromIntSet = EMS . IMS.fromSet