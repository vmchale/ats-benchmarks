{-# LANGUAGE ForeignFunctionInterface #-}

module Lib
    ( collatzPure
    , collatzStack
    ) where

import           Foreign.C

foreign import ccall unsafe collatz :: CInt -> CInt

collatzStack :: Int -> Int
collatzStack = fromIntegral . collatz . fromIntegral

collatzPure :: Int -> Int
collatzPure 1 = 1
collatzPure n
    | n `mod` 2 == 0 = collatzPure (n `div` 2) + 1
    | otherwise = collatzPure (3 * n + 1) + 1
