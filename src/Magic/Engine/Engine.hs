module Magic.Engine.Engine where

import qualified Data.Dict as D

import Control.Algebra
import Control.Effect.State (get, gets)
import Control.Effect.Reader (ask)

import Magic.Engine.MagicGame
import Magic.Engine.Types.World
import Magic.Engine.Types.Player (Player(Player))
import Utils.MaybeEither (loopEither)
import Magic.Server.ServerCommunicator (ServerPlayerRef)
import Types.World (World(_players))
import Data.Maybe (Maybe(Just, Nothing), catMaybes)
import Control.Monad (forM_)
import Magic.Server.ServerInterpreter (Question(AskYesNo))
import Data.Either (Either(Right))


setupGame :: MagicGameConfig -> (MagicWorld, MagicGameConfig)
setupGame config = let (wps, cps) = players D.empty D.empty . keys . _playersCards $ config in (world, config{ _playersMap = cps})
    where
        players cps wps [] = (cps, wps)
        players cps wps (p:ps) = let (wp, wps') = D.put emptyPlayer wps in players (D.put wp p, wps')
        world = emptyWorld {
            _players = wps,
            _priorityOrder = keys wps,
            _zones = Zones {
                library = D.fromList . map (\p -> Zone (Just p) (D.fromList . map (\c -> c p) . find p $ _playersCards config)) $ keys wps,
                hand = D.fromList . map (\p -> Zone (Just p) D.empty) $ keys wps,
                graveyard = D.fromList . map (\p -> Zone (Just p) D.empty) $ keys wps,
                exile = Zone Nothing D.empty,
                battlefield = Zone Nothing D.empty,
                stack = Zone Nothing D.empty
            }
        } 

startGame :: Has MagicGame m => m ()
startGame = do
    dealHands
    p <- loopMaybe mainGameLoop
    case p of
        [] -> broadcastMessageInst "Game ended in a Draw with no winners"
        [p] -> broadcastMessageInst "Game ended with a winner:  " ++ p 
        ps -> broadcastMessageInst "Game ended in a Draw among these players: " ++ p 

dealHands :: Has MagicGame m => m ()
dealHands = do
    ps <- gets $ keys . _players
    mulligan $ map (\x -> (x, 7)) ps

mulligan :: Has MagicGame m => [(PlayerRef, Int)] -> m ()
mulligan numMulls = do
    nextMulls <- forM numMulls $ \(p,n) -> do 
        currHand <- gets $ keys . objects . fromJust . find p . hand . _zones
        runEffects $ map (\objRef -> MoveObject (MkObjectZoneRef (Hand p) objRef) (Library p)) currHand
        runEffects [ShuffleDeck p]
        runEffects [DrawCards p n]
        keep <- askQuestion ("Keep hand? (Next hand = "++show(n-1)++")") AskYesNo Right
        if keep && n > 1 then return (Just (p,n-1)) else return Nothing
    case catMaybes nextMulls of
        [] -> return ()
        ps -> mulligan ps

mainGameLoop :: Has MagicGame m => m (Maybe [ServerPlayerRef])
mainGameLoop = undefined
