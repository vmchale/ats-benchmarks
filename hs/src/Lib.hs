{-# LANGUAGE ForeignFunctionInterface #-}

module Lib
    ( collatzPure
    , collatzATS
    , collatzC
    , factorialATS
    , factorialPure
    , derangement
    , derangementATS
    ) where

import           Control.Monad
import           Data.GMP
import           Foreign.C
import           Foreign.Ptr
import           Foreign.Storable

foreign import ccall unsafe collatz :: CInt -> CInt
foreign import ccall unsafe collatz_c :: CInt -> CInt
foreign import ccall unsafe factorial :: CInt -> CInt
foreign import ccall unsafe derangement_ats :: CInt -> Ptr GMPInt

derangement :: Int -> Integer
derangement n = derangements !! n

derangements :: [Integer]
derangements = fmap snd g
    where g = (0, 1) : (1, 0) : zipWith (\(_, n) (i, m) -> (i + 1, i * (n + m))) g (tail g)

collatzC :: Int -> Int
collatzC = fromIntegral . collatz_c . fromIntegral

derangementATS :: Int -> IO Integer
derangementATS = gmpToInteger <=< (peek . derangement_ats . fromIntegral)

factorialATS :: Int -> Int
factorialATS = fromIntegral . factorial . fromIntegral

factorialPure :: Int -> Int
factorialPure 0 = 1
factorialPure n = n * factorialPure (n-1)

collatzATS :: Int -> Int
collatzATS = fromIntegral . collatz . fromIntegral

collatzPure :: Int -> Int
collatzPure 1 = 1
collatzPure n
    | n `mod` 2 == 0 = collatzPure (n `div` 2) + 1
    | otherwise = collatzPure (3 * n + 1) + 1
