module Magic.Server.ServerInterpreter where

import Control.Algebra
import Magic.Server.ServerCommunicator    
import Data.Serializable (Serializable)

type QuestionValidation a b = a -> Either ServerText b
data Question a where
    ChooseOne :: Serializable ServerText c => [c] -> Question c
    ChooseMaybe :: Serializable ServerText c => [c] -> Question (Maybe c)
    ChooseSeveral :: Serializable ServerText c => [c] -> Question [c]
    AskNumber :: Question Integer
    AskYesNo :: Question Bool

data ServerInstruction p a where
    BroadcastMessageInst :: ServerText -> ServerInstruction p ()
    SendMessageInst :: p -> ServerText -> ServerInstruction p ()
    SendQuestionInst :: p -> ServerText -> Question a -> QuestionValidation a b -> ServerInstruction p b
    
data ServerInterpreter (m :: * -> *) k where
    ServerInstruction :: ServerInstruction ServerPlayerRef a -> ServerInterpreter m a

broadcastMessageInst :: Has ServerInterpreter sig m => ServerText -> m ()
broadcastMessageInst = send . ServerInstruction . BroadcastMessageInst

sendMessageInst :: Has ServerInterpreter sig m => ServerPlayerRef -> ServerText -> m ()
sendMessageInst p = send . ServerInstruction . SendMessageInst p

sendQuestionInst :: Has ServerInterpreter sig m => ServerPlayerRef -> ServerText -> Question a -> QuestionValidation a b -> m b
sendQuestionInst p t q = send . ServerInstruction . SendQuestionInst p t q
