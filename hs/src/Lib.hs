{-# LANGUAGE ForeignFunctionInterface #-}

module Lib
    ( collatzPure
    , collatzATS
    , collatzC
    , factorialATS
    , factorial
    , derangement
    , derangementATS
    , fibonacci
    , fibonacciATS
    ) where

import           Data.GMP
import           Foreign.C
import           Foreign.Ptr

{-# SPECIALIZE factorial :: Int -> Integer #-}

foreign import ccall unsafe collatz :: CInt -> CInt
foreign import ccall unsafe collatz_c :: CInt -> CInt
foreign import ccall unsafe derangement_ats :: CInt -> Ptr GMPInt
foreign import ccall unsafe fib_ats :: CInt -> Ptr GMPInt
foreign import ccall unsafe factorial_ats_big :: CInt -> Ptr GMPInt

factorials :: (Integral a) => [a]
factorials = 1 : 1 : zipWith (*) [2..] (tail factorials)

factorial :: (Integral a) => Int -> a
factorial = (factorials !!)

fibs :: [Integer]
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

fibonacci :: Int -> Integer
fibonacci = (fibs !!)

derangement :: Int -> Integer
derangement = (derangements !!)

derangements :: [Integer]
derangements = fmap snd g
    where g = (0, 1) : (1, 0) : zipWith (\(_, n) (i, m) -> (i + 1, i * (n + m))) g (tail g)

collatzC :: Int -> Int
collatzC = fromIntegral . collatz_c . fromIntegral

fibonacciATS :: Int -> IO Integer
fibonacciATS = conjugateGMP fib_ats

derangementATS :: Int -> IO Integer
derangementATS = conjugateGMP derangement_ats

factorialATS :: Int -> IO Integer
factorialATS = conjugateGMP factorial_ats_big

collatzATS :: Int -> Int
collatzATS = fromIntegral . collatz . fromIntegral

collatzPure :: Int -> Int
collatzPure 1 = 1
collatzPure n
    | n `mod` 2 == 0 = collatzPure (n `div` 2) + 1
    | otherwise = collatzPure (3 * n + 1) + 1
