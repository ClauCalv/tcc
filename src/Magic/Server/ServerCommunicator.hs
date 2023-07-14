module Magic.Server.ServerCommunicator where

import Control.Algebra

type ServerText = String -- | Data.Text
type ServerPlayerRef = Int
type ServerWorld = ServerText

data ServerCommand = Answer ServerText | ViewWorld | ForceQuit deriving (Show, Read)
data ServerCommunication a where 
    BroadcastMessage :: ServerText -> ServerCommunication ()
    SendMessage :: ServerPlayerRef -> ServerText -> ServerCommunication ()
    WaitAnswer :: ServerPlayerRef -> ServerCommunication (Maybe ServerText)
    UpdateWorld :: ServerWorld -> ServerCommunication ()
    
data ServerCommunicator (m :: * -> *) k where
    ServerCommunication :: ServerCommunication a -> ServerCommunicator m a

broadcastMessage :: Has ServerCommunicator sig m => ServerText -> m ()
broadcastMessage = send . ServerCommunication . BroadcastMessage

sendMessage :: Has ServerCommunicator sig m => ServerPlayerRef -> ServerText -> m ()
sendMessage p = send . ServerCommunication . SendMessage p

waitAnswer :: Has ServerCommunicator sig m => ServerPlayerRef -> m (Maybe ServerText)
waitAnswer = send . ServerCommunication . WaitAnswer

updateWorld :: Has ServerCommunicator sig m =>  ServerWorld -> m ()
updateWorld =send . ServerCommunication . UpdateWorld