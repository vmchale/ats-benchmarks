module Main where

import           Criterion.Main
import           Lib

constant :: Int
constant = 10971

main :: IO ()
main =
    defaultMain [ bgroup "collatz"
                      [ bench "collatzH" $ nf collatzH constant
                      , bench "collatzStack" $ nf collatzStack constant
                      , bench "collatzPure" $ nf collatzPure constant ]
                ]
