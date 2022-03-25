{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    -- KindSignatures,            -- Defining types that consumes kinds other than Type (like Type -> Type)
    -- GADTs,                     -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    -- UndecidableInstances,      -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    --TypeOperators,              -- Needed for composing types like sig

    TypeApplications              -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module MagicGame where

import Control.Algebra
import Effects.Server

import qualified Data.Dict as D
import Types.MagicGameTypes
import Types.World
import Types.Players

data GameInitialParams = GameInitialParams 
    { _initialPlayers  :: [ServerPlayerRef]
    , _initialGameMode :: GameMode
    }


startGame :: Has E_Server sig m => GameInitialParams -> m ()
startGame params = evalState (makeInitialState params) $
                    --runMagicGameCarrier $
                    do
                        dealHands
                        forever $ doGameLoop

makeInitialState :: GameInitialParams -> GameState
makeInitialState params = gameState
    where
        newPlayers = newPlayers' (D.empty, []) $ _initialPlayers params
        newPlayers' (d, ys) [] = (d, ys)
        newPlayers' (d, ys) (x:xs) = let (rf, d') = D.put d (newPlayer x)
                                     in newPlayers' (d', (rf, x):ys) xs
        
        newPlayer x = Player
            { _pv = 20
            }

        gameState = GameState
            { _world            = world
            , _gameMode         = _initialGameMode params
            , _history          = ()
            , _playerMapping    = snd newPlayers
            }

        world = World 
            { _players          = fst newPlayers
            , _priorityPlayer   = fst . head . snd $ newPlayers
            , _turn             = ()
            , _zones            = zones
            }

        zones = Zones
            { _exile        = D.empty
            , _battlefield  = D.empty
            , _stack        = D.empty
            , _command      = D.empty
            , _library      = D.fromList $ map (\(x,_) -> (x, D.empty)) $ snd newPlayers
            , _hand         = D.fromList $ map (\(x,_) -> (x, D.empty)) $ snd newPlayers
            , _graveyard    = D.fromList $ map (\(x,_) -> (x, D.empty)) $ snd newPlayers
            } 
        
        