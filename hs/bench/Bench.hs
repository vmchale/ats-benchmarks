module Main where

import           Criterion.Main
import           Lib

main :: IO ()
main =
    defaultMain [ bgroup "collatz"
                      [ bench "collatzH" $ nf collatzH 2223
                      , bench "collatzStack" $ nf collatzStack 2223
                      , bench "collatzPure" $ nf collatzPure 2223 ]
                ]
