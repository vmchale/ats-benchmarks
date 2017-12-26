{-# LANGUAGE ForeignFunctionInterface #-}

module Lib
    ( collatzPure
    , collatzStack
    , collatzC
    ) where

import           Foreign.C

foreign import ccall unsafe collatz :: CInt -> CInt
foreign import ccall unsafe collatz_c :: CInt -> CInt

collatzC :: Int -> Int
collatzC = fromIntegral . collatz_c . fromIntegral

collatzStack :: Int -> Int
collatzStack = fromIntegral . collatz . fromIntegral

collatzPure :: Int -> Int
collatzPure 1 = 1
collatzPure n
    | n `mod` 2 == 0 = collatzPure (n `div` 2) + 1
    | otherwise = collatzPure (3 * n + 1) + 1
