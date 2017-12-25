{-# LANGUAGE ForeignFunctionInterface #-}

module Lib
    ( collatzH
    , collatzPure
    , collatzStack
    ) where

import           Foreign.C

foreign import ccall unsafe collatz :: CInt -> CInt
foreign import ccall unsafe collatz_stack :: CInt -> CInt

collatzStack :: Int -> Int
collatzStack = fromIntegral . collatz_stack . fromIntegral

collatzPure :: Int -> Int
collatzPure 1 = 1
collatzPure n
    | n `mod` 2 == 0 = collatzPure (n `div` 2) + 1
    | otherwise = collatzPure (3 * n + 1) + 1

collatzH :: Int -> Int
collatzH = fromIntegral . collatz . fromIntegral
