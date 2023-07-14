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

module Data.Dict where
import Data.Maybe (isJust, fromJust)
import Optics (Index, IxValue, Ixed(..), An_AffineTraversal, AffineTraversal', atraversal)
import Data.Either.Extra (maybeToEither)

class UniqDict d where
    type RefOf d
    getNext :: UniqDict d => d a -> RefOf d
    find :: UniqDict d => RefOf d -> d a -> Maybe a
    put :: UniqDict d => a -> d a -> (RefOf d, d a)
    remove :: UniqDict d => RefOf d -> d a -> (Maybe a, d a)
    modify :: UniqDict d => (a -> a) -> RefOf d -> d a -> d a
    modifyAll :: UniqDict d => (a -> Maybe b) -> d a -> d b
    keys :: UniqDict d => d a -> [RefOf d]
    values :: UniqDict d => d a -> [a]

    dmap :: UniqDict d => (a -> b) -> d a -> d b
    dmap f = modifyAll (Just . f)
    putAll :: UniqDict d => [a] -> d a -> d a
    putAll [] d = d
    putAll (a:as) d = putAll as . snd . put a $ d

type instance Index (AssocDict k v) = k
type instance IxValue (AssocDict k v) = v
instance Ixed (AssocDict k v) where
    type IxKind (AssocDict k v) = An_AffineTraversal
    ix :: k -> AffineTraversal' (AssocDict k v) v
    ix k = atraversal (\l -> maybeToEither l $ find k l) (\l v -> modify (const v) k l)

type AssocList k v = [(k, v)]
data AssocDict k v where 
    AssocDict :: (Eq k, Enum k) => k -> AssocList k v -> AssocDict k v

empty :: (Eq k, Enum k, Bounded k) => AssocDict k v
empty = emptyWith minBound

emptyWith :: (Eq k, Enum k) => k -> AssocDict k v
emptyWith x = AssocDict x []

fromList :: (Eq k, Enum k, Bounded k) => [v] -> AssocDict k v
fromList as = putAll as empty

instance UniqDict (AssocDict k) where
    type RefOf (AssocDict k) = k
    getNext (AssocDict k _) = k
    find k (AssocDict _ m) = lookup k m
    put v (AssocDict k m) = let k' = succ k in (k, AssocDict k' ((k,v):m))
    remove k' (AssocDict kd m) = let (v', m') = remove' k' m in (v', AssocDict kd m')
        where
            remove' :: k -> AssocList k v -> (Maybe v, AssocList k v)
            remove' _ [] = (Nothing, [])
            remove' k' ((k,v) : m) = if k == k' then (Just v, m) else let (v'',m') = remove' k' m in (v'', (k,v) : m') 
    modify f k' (AssocDict kd m) = AssocDict kd $ fmap (\(k, v) -> if k == k' then (k, f v) else (k,v)) m
    modifyAll f (AssocDict kd m) = AssocDict kd $ modifyAll' f m
        where
            modifyAll' :: (v -> Maybe v') -> AssocList k v -> AssocList k v'
            modifyAll' _ [] = []
            modifyAll' f ((k,v) : m) = let v' = f v in if isJust v' then (k, fromJust v') : modifyAll' f m else modifyAll' f m
    keys (AssocDict _ m) = fmap fst m
    values (AssocDict _ m) = fmap snd m

