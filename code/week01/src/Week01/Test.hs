{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Week01.Test where

import Control.Monad hiding (fmap)
import Data.Default (Default (..))
import qualified Data.Map as Map
import Data.Monoid (Last (..))
import Data.Text (Text)
import Ledger
import Ledger.Ada as Ada
import Ledger.CardanoWallet as CW
import Ledger.TimeSlot
import Ledger.Value as Value
import Plutus.Contract as Contract
import Plutus.Trace (callEndpoint)
import qualified Plutus.Trace as Emulator
import Plutus.Trace.Emulator as Emulator
import PlutusTx.Prelude hiding (Semigroup (..), unless)
import qualified Wallet.Emulator as Wallet
import Wallet.Emulator.Wallet
import Week01.EnglishAuction
import Prelude (IO, Semigroup (..), Show (..))

assetSymbol = "ff"

assetToken = "T"

wallets :: [Wallet]
wallets = toMockWallet <$> CW.knownMockWallets

test :: IO ()
test = runEmulatorTraceIO' def emCfg myTrace
  where
    v :: Value
    v = Ada.lovelaceValueOf 100_000_000

    v' :: Value
    v' = v <> Value.singleton assetSymbol assetToken 1

    mwMap :: Map.Map Wallet Value
    mwMap = Map.fromList $ (,v') <$> [head wallets]

    owMap :: Map.Map Wallet Value
    owMap = Map.fromList $ (,v) <$> tail wallets

    walletMap = mwMap <> owMap

    emCfg :: EmulatorConfig
    emCfg = EmulatorConfig (Left walletMap) def def

myTrace :: EmulatorTrace ()
myTrace = do
  h1 <- activateContractWallet (head wallets) endpoints
  h2 <- activateContractWallet (wallets !! 1) endpoints
  h3 <- activateContractWallet (wallets !! 2) endpoints

  callEndpoint @"start" h1 $
    StartParams
      { spDeadline = slotToEndPOSIXTime def 10,
        spMinBid = 10 * 1000000,
        spCurrency = assetSymbol,
        spToken = assetToken
      }

  void $ Emulator.waitNSlots 1

  callEndpoint @"bid" h2 $
    BidParams
      { bpCurrency = assetSymbol,
        bpToken = assetToken,
        bpBid = 10 * 1000000
      }

  void $ Emulator.waitNSlots 1

  callEndpoint @"bid" h3 $
    BidParams
      { bpCurrency = assetSymbol,
        bpToken = assetToken,
        bpBid = 15 * 1000000
      }

  void $ Emulator.waitUntilSlot 11

  callEndpoint @"close" h3 $
    CloseParams
      { cpCurrency = assetSymbol,
        cpToken = assetToken
      }

  void $ Emulator.waitNSlots 1
