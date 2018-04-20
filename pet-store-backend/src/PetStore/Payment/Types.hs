{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE NamedFieldPuns #-}
module PetStore.Payment.Types where

import           Data.Aeson
import           Data.Char    (digitToInt, isDigit)
import           GHC.Generics

data Payment = Payment { cardNumber :: String }
             deriving (Eq,Show,Generic,ToJSON,FromJSON)

checkCardNumber :: Payment -> Bool
checkCardNumber Payment{cardNumber} =
  computeLuhn (reverse cardNumber) 0
  where
    computeLuhn (_:n:rest) k
      | isDigit n = computeLuhn rest (k + reduce n)
      | otherwise = False
    computeLuhn _          k = k == 0

    reduce c =
      let n = 2 * digitToInt c
      in if n > 10
         then (n - 10) + 1
         else n

data PaymentResult = PaymentResult { _id     :: Integer
                                   , _result :: String
                                   }
  deriving (Eq,Show,Generic,ToJSON,FromJSON)
