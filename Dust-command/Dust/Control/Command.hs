module Dust.Control.Command
(
  processCommand
)
where

import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Data.Word
import Data.Binary (encode)
import Control.Monad.State.Lazy
import Control.Lens

import Dust.Model.TrafficModel
import Dust.Crypto.PRNG
import Dust.Control.Protocol
import Dust.Control.State

processCommand :: ControlRequest -> State TrafficGenerator (Maybe BL.ByteString)
processCommand (PacketCount ms) = do
  let count = 0 :: Word16
  return $ Just $ encode count
processCommand EncodedReady = do
  gen <- get
  let (result, gen') = runState generateLength gen
  put gen'
  return $ Just $ encode result
processCommand (PutDecoded bs) = do
  return Nothing
processCommand (GetEncoded len) = do
  let bs = B.empty
  return $ Just $ encode bs
processCommand (DecodedReady) = do
  let count = 0 :: Word16
  return $ Just $ encode count
processCommand (PutEncoded bs) = do
  return Nothing
processCommand (GetDecoded len) = do
  let bs = B.empty
  return $ Just $ encode bs
