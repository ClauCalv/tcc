{-# LANGUAGE 
    
    -- ExistentialQuantification, -- Advanced types
    -- RankNTypes,                -- Advanced types

    -- KindSignatures,            -- Defining types that consumes kinds other than Type (like Type -> Type)
    GADTs,                        -- Defining types that fixates a type variable pattern-matching it
    -- TypeFamilies,              -- Alternative to GADTs, defines type equality (= fixating a type variable)

    MultiParamTypeClasses,        -- Defining complex classes (like Algebra)
    -- FlexibleContexts,          -- Using complex classes in constraints
    FlexibleInstances,            -- Implementing complex classes' instances (like Algebra)
    UndecidableInstances,         -- For instances that may make type-checker loop (like 'Has Eff sig m' context)
    
    TypeOperators,                -- Needed for composing types like sig

    -- TypeApplications,          -- Defining type in expression via @
    -- OverloadedStrings,         -- Treating string literals via IsString instead of defaulting to [Char]
    GeneralizedNewtypeDeriving    -- Code shortening, unnecessary but useful.
#-}

module Effects.Server.LocalServer  (
  module Effects.Server.LocalServer,
  module Effects.Server
) where


-- from base
import Control.Applicative
-- from fused-effects
import Control.Algebra
-- from transformers
import Control.Monad.IO.Class
-- From aeson
--import Data.Aeson
-- From bytestring
--import qualified Data.ByteString.Char8 as B
--import qualified Data.ByteString.Lazy as L
-- From Effects
import Effects.Server
import Effects.IOFormatter
import Data.List.Index (ireplicateM)
import Data.Char (isSpace)
import Optics
import IOUtils


-- Local server impl

newtype C_LocalServer m a = C_LocalServer { runLocalServer :: m a }
  deriving (Applicative, Functor, Monad, MonadIO)

--Meaning: 'C_LocalServer m' implements 'E_Server', only if 'm is MonadIO', depending on 'E_IOFormatter'
instance (MonadIO m, 
          Has (E_IOFormatter String) sig m,
          Algebra sig m
          ) => Algebra (E_Server :+: sig) (C_LocalServer m) where
  alg hdl sig ctx = case sig of
    L (RunInstruction i) -> (<$ ctx) <$> doRunInstruction i
    R other      -> C_LocalServer (alg (runLocalServer . hdl) other ctx)

doRunInstruction :: (MonadIO m, Has (E_IOFormatter String) sig m, Read a) => Instruction b a -> m a
doRunInstruction i = case i of
    (Broadcast a)   -> liftIO $ putStrLn (show a)
    (Send p a)      -> liftIO $ putStrLn (show a)
    (Ask p a q)     -> liftIO $ do
        putStrLn (show a) 
        answ <- getInputLoopWithMessage 
            ("Insira uma resposta válida") 
            Just
        return answ 
    (Choose p a bs) -> liftIO $ do 
        putStrLn (show a)
        let len = length bs
        putStrLn $ "Opções: " ++ show (zip [1..] bs)
        n <- getInputLoopWithMessage 
            ("Insira um número entre 1 e " ++ show len) 
            (assertMany [(> 0), (<= len)])
        return (bs !! n) -- replace with something safe?
    (MaybeChoose p a bs) -> liftIO $ do 
        putStrLn (show a)
        let len = length bs
        putStrLn $ "Opções: " ++ show (zip [1..] bs)
        n <- getInputLoopWithMessage 
            ("Insira um número entre 0 e " ++ show len ++ " onde 0 significa nenhuma das alternativas (NDA)") 
            (assertMany [(>= 0), (<= len)])
        return $ if n == 0 then Nothing else Just (bs !! n)


