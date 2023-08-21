module Magic.Engine.Engine where

import qualified Magic.Data.Dict as D

import Control.Algebra
import Control.Effect.State (get, gets, State)
import Control.Effect.Reader (ask, Reader)

import Magic.Engine.MagicGame
import Magic.Engine.Types.World
import Magic.Engine.Types.Player
import Utils.MaybeEither (loopEither)
import Magic.Server.ServerCommunicator (ServerPlayerRef)

import Data.Maybe (Maybe(Just, Nothing), catMaybes, fromJust)
import Control.Monad (forM_)
import Magic.Server.ServerInterpreter (Question(AskYesNo))
import Data.Either (Either(Right))
import Magic.Engine.Types.Object (Card)
import Magic.Engine.Types.Zone (initializeZones, atZone, ZoneRef (Library), objects)

import Optics hiding (modifying, modifying', assign, assign', use, preuse)
import Control.Effect.Optics


setupGame :: D.AssocList ServerPlayerRef [Card] -> (MagicWorld, MagicGameConfig)
setupGame cards = (world, gameConfig)
    where
        worldplayers = D.fromList . map (const emptyPlayer) . D.keys $ cards
        playersMap' = zip (D.keys cards) (D.keys worldplayers)
        playersCards' = map (\(sp, cs) -> (lookup sp playersMap',cs)) cards
        gameConfig = emptyMagicGameConfig 
                        & playersMap .~ playersMap'
                        & playersCards .~ playersCards'
        world = emptyWorld 
            & players .~ worldplayers
            & zones .~ initializeZones (D.keys worldplayers)

startGame :: Has MagicGame sig m => m ()
startGame = do
    initDecks
    dealHands
    p <- loopMaybe mainGameLoop
    case p of
        [] -> broadcastMessageInst "Game ended in a Draw with no winners"
        [p] -> broadcastMessageInst "Game ended with a winner:  " ++ p 
        ps -> broadcastMessageInst "Game ended in a Draw among these players: " ++ p 

initDecks :: (Has MagicGame sig m, Has (Reader MagicGameConfig) sig m, Has (State MagicWorld) sig m) => m ()
initDecks = do
    ps <- use players
    mapM_ initDeck (D.keys ps)
    where
        initDeck p = do
            cards <- preuse $ playersCards % ix p
            modifying (zones % atZone (Library p) % objects) $ D.putAll (map ($ p) (fromJust cards))
            


dealHands :: Has MagicGame sig m => m ()
dealHands = do
    ps <- gets $ keys . _players
    mulligan $ map (\x -> (x, 7)) ps

mulligan :: Has MagicGame sig m => [(PlayerRef, Int)] -> m ()
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

mainGameLoop :: Has MagicGame sig m => m (Maybe [ServerPlayerRef])
mainGameLoop = undefined
