{-# LANGUAGE ForeignFunctionInterface #-}

module Lib
    ( collatzH
    , collatzPure
    ) where

import           Foreign.C

foreign import ccall unsafe collatz :: CInt -> CInt

collatzPure :: Int -> Int
collatzPure 1 = 1
collatzPure n
    | n `mod` 2 == 0 = collatzPure (n `div` 2) + 1
    | otherwise = collatzPure (3 * n + 1) + 1

collatzH :: Int -> Int
collatzH x =
  fromIntegral $ collatz (fromIntegral x)
