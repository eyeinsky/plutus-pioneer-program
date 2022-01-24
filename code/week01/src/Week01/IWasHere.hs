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

data Message = Message
  { messageAuthor :: Integer -- TODO: this should be a string
  , messageContent :: Integer -- TODO: this should be a string
  } deriving P.Show

PlutusTx.unstableMakeIsData ''Message
PlutusTx.makeLift ''Message

data Action = WriteMessage -- Message content

PlutusTx.unstableMakeIsData ''Action
PlutusTx.makeLift ''Action

data Datum = Datum
PlutusTx.unstableMakeIsData ''Datum
PlutusTx.makeLift ''Datum

data IWasHere
instance Scripts.ValidatorTypes IWasHere where
  type instance RedeemerType IWasHere = ()
  type instance DatumType IWasHere = ()

-- * Validator

{-# INLINABLE mkValidator #-}
mkValidator :: () -> () -> ScriptContext -> Bool
mkValidator _ _ _ = False -- FIX ME!

typedValidator :: Scripts.TypedValidator IWasHere
typedValidator = Scripts.mkTypedValidator @IWasHere
    $$(PlutusTx.compile [|| mkValidator ||])
    $$(PlutusTx.compile [|| wrap ||])
  where
    wrap = Scripts.wrapValidator @(Scripts.RedeemerType IWasHere) @(Scripts.DatumType IWasHere)

validator :: Validator
validator = Scripts.validatorScript typedValidator

valHash :: Ledger.ValidatorHash
valHash = Scripts.validatorHash typedValidator

scrAddress :: Ledger.Address
scrAddress = scriptAddress validator

-- * Off-chain

type Schema = Endpoint "write" WriteParams

writeMessage :: AsContractError e => Message -> Contract w s e ()
writeMessage msg = do
  -- TODO write to actual blockchain
  logInfo @P.String $ printf "%s wrote \"%s\" onto the blockchain" (messageAuthor msg) (messageContent msg)

data WriteParams

hot :: IO ()
hot = P.putStrLn "hello there"
