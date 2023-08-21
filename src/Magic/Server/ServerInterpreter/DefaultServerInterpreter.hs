{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    KindSignatures,               -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    TypeFamilies,                  -- Alternative to GADTs, defines type equality (= fixating a type variable)

    -- MultiParamTypeClasses,     -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    -- FlexibleInstances,         -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances          -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    -- TypeOperators,             -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    -- GeneralizedNewtypeDeriving -- Code shortening, unnecessary but useful.
#-}

module Magic.Server.ServerInterpreter.DefaultServerInterpreter where

import Control.Algebra

import Magic.Server.ServerCommunicator
import Magic.Server.ServerInterpreter

import Control.Monad (when, forM_)

import Text.Read (readMaybe)
import Data.Maybe (isJust, fromJust, isNothing)
import Utils.MaybeEither (loopEither, mapLeft)

import Data.Class.Serializable (Serializable (serialize))

newtype DefaultServerInterpreter m a = DefaultServerInterpreter { runDefaultServerInterpreter :: m a }
    deriving (Applicative, Functor, Monad)

type DefaultServerInterpreterConstraint sig m = (Has ServerCommunicator sig m, Algebra sig m)

instance DefaultServerInterpreterConstraint sig m => Algebra (ServerInterpreter :+: sig) (DefaultServerInterpreter m) where
  alg hdl sig ctx = case sig of
    L (ServerInstruction c) -> (<$ ctx) <$> doInstruction c
    R other -> DefaultServerInterpreter (alg (runDefaultServerInterpreter . hdl) other ctx)

doInstruction :: DefaultServerInterpreterConstraint sig m => ServerInstruction ServerPlayerRef a -> m a
doInstruction (BroadcastMessageInst t) = broadcastMessage t
doInstruction (SendMessageInst p t) = sendMessage p t
doInstruction (SendQuestionInst p t q v) = do
    let qt = t ++ "\n" ++ getQuestionMessage q
    loopEither (getAnswerLoop qt q v p) Nothing

getQuestionMessage :: Question b -> ServerText
getQuestionMessage (ChooseOne bs) = foldr (\x acc -> x ++ "\n" ++ acc) "Choose one between :" $ enumerateItems bs
getQuestionMessage (ChooseMaybe bs) = foldr (\x acc -> x ++ "\n" ++ acc) "Choose \"None\" or one between :" $ enumerateItems bs
getQuestionMessage (ChooseSeveral bs) = foldr (\x acc -> x ++ "\n" ++ acc) "Choose some between :" $ enumerateItems bs
getQuestionMessage AskNumber = "Choose a number :"
getQuestionMessage AskYesNo = "Choose \"Yes\" or \"No\" :"

enumerateItems :: Serializable ServerText b => [b] -> [String]
enumerateItems = fmap (\(i, b) -> show i ++ " - " ++ serialize b) . zip [1..]

getAnswerLoop :: DefaultServerInterpreterConstraint sig m => 
        ServerText ->                   -- question message
        Question a ->                   -- question
        QuestionValidation a b ->       -- question validation
        ServerPlayerRef ->              -- target player
        Maybe String ->                 -- error message
        m (Either (Maybe String) b)
getAnswerLoop t q v p err = do
    mapM_ (sendMessage p) err
    sendMessage p t
    answ <- waitAnswer p
    return . mapLeft Just . tryGetAnswer q v $ answ

tryGetAnswer :: Question a -> QuestionValidation a b -> Maybe ServerText -> Either ServerText b
tryGetAnswer q v mAnsw = 
    if isNothing mAnsw 
    then Left "No Answer Provided" 
    else let answ = fromJust mAnsw in case q of
        (ChooseOne as) -> do
            num <- case readMaybe @Int answ of
                Just x -> Right x
                Nothing -> Left "Invalid Number"
            a <- if num <= 0 || num > length as then Left "Invalid Option" else Right (as !! (num - 1))
            v a
        (ChooseMaybe as) -> 
            if answ == "None" 
            then v Nothing 
            else do
                num <- case readMaybe @Int answ of
                    Just x -> Right x
                    Nothing -> Left "Invalid Number"
                a <- if num <= 0 || num > length as then Left "Invalid Option" else Right (as !! (num - 1))
                v (Just a)
        (ChooseSeveral as) -> do
            nums <- case readMaybe @[Int] answ of
                Just x -> Right x
                Nothing -> Left "Invalid Number"
            a <- if any (\num -> num <= 0 || num > length as) nums then Left "Invalid Option" else Right (map (as !!) nums)
            v a
        AskNumber -> do
            num <- case readMaybe @Int answ of
                Just x -> Right (fromIntegral x)
                Nothing -> Left "Invalid Number"
            v num
        AskYesNo -> do
            yn <- case answ of
                "Yes" -> Right True
                "No" -> Right False
                _ -> Left "Invalid option"
            v yn
