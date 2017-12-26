module Main where

import           Criterion.Main
import           Lib

main :: IO ()
main =
    defaultMain [ bgroup "collatzStack"
                      [ bench "2223" $ nf collatzStack 2223
                      , bench "10971" $ nf collatzStack 10971
                      , bench "106239" $ nf collatzStack 106239
                      ]
                , bgroup "collatzC"
                      [ bench "2223" $ nf collatzC 2223
                      , bench "10971" $ nf collatzC 10971
                      , bench "106239" $ nf collatzC 106239
                      ]
                ]
