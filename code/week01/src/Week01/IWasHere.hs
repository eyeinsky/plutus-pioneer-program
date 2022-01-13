{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase                 #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE NoImplicitPrelude          #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE RecordWildCards            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE TypeFamilies               #-}
{-# LANGUAGE TypeOperators              #-}

module Week01.IWasHere where

import           Control.Monad        hiding (fmap)
import           Data.Aeson           (ToJSON, FromJSON)
import           Data.List.NonEmpty   (NonEmpty (..))
import           Data.Map             as Map
import           Data.Text            (pack, Text)
import           GHC.Generics         (Generic)
import           Ledger               hiding (singleton, Datum)
import qualified Ledger.Constraints   as Constraints
import qualified Ledger.Typed.Scripts as Scripts
import           Ledger.Value         as Value
import           Ledger.Ada           as Ada
-- import           Playground.Contract  (IO, ensureKnownCurrencies, printSchemas, stage, printJson)
import           Playground.Contract  (IO)
import           Playground.TH        (mkKnownCurrencies, mkSchemaDefinitions)
import           Playground.Types     (KnownCurrency (..))
import           Plutus.Contract
import qualified PlutusTx
import           PlutusTx.Prelude     hiding (unless)
import qualified Prelude              as P
import           Schema               (ToSchema)
import           Text.Printf          (printf)

-- * Data types

data Message = Message
  { messageAuthor :: !PaymentPubKeyHash
  -- , messageContent :: P.String -- ..or something
  } deriving P.Show

PlutusTx.unstableMakeIsData ''Message
PlutusTx.makeLift ''Message

data Action = WriteMessage -- Message content

PlutusTx.unstableMakeIsData ''Action
PlutusTx.makeLift ''Action

data Datum = Datum
PlutusTx.unstableMakeIsData ''Datum
PlutusTx.makeLift ''Datum

data Writing
instance Scripts.ValidatorTypes Writing where
    type instance RedeemerType Writing = Action
    type instance DatumType Writing = Action

-- *

{-# INLINABLE writeMessage #-}
writeMessage :: Datum -> Datum
writeMessage Datum = Datum

data StartParams
data WriteParams

type Schema =
      Endpoint "start" StartParams
  .\/ Endpoint "write" WriteParams

hot :: IO ()
hot = P.putStrLn "hello there"
