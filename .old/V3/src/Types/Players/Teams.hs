module Types.Players.Teams where

import qualified Data.Dict as D

import Types.Players.Player

type Teams = [(D.RefOf Player, TeamId)]

type TeamId = Int

getTeamUnsafe :: Teams -> D.RefOf Player -> TeamId
getTeamUnsafe ts p = head $ map snd $ filter (\x -> (fst x) == p) ts

teammates :: Teams -> D.RefOf Player -> [D.RefOf Player]
teammates ts p = map fst $ filter (\x -> (snd x) == (getTeamUnsafe ts p)) ts

opponents :: Teams -> D.RefOf Player -> [D.RefOf Player]
opponents ts p = map fst $ filter (\x -> (snd x) /= (getTeamUnsafe ts p)) ts

