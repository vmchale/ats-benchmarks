module Main where

import           Criterion.Main
import           Lib

main :: IO ()
main =
    defaultMain [ bgroup "collatzATS"
                      [ bench "2223" $ nf collatzATS 2223
                      , bench "10971" $ nf collatzATS 10971
                      , bench "106239" $ nf collatzATS 106239
                      ]
                , bgroup "collatzC"
                      [ bench "2223" $ nf collatzC 2223
                      , bench "10971" $ nf collatzC 10971
                      , bench "106239" $ nf collatzC 106239
                      ]
                , bgroup "factorialATS"
                      [ bench "13" $ nf factorialATS 13
                      ]
                , bgroup "factorialPure"
                      [ bench "13" $ nf factorialPure 13
                      ]
                , bgroup "derangement"
                      [ bench "derangement (64)" $ nf derangement 64
                      , bench "id (96800425246141091510518408809597121)" $ nf id (96800425246141091510518408809597121 :: Integer)
                      , bench "derangementATS (64)" $ nfIO (derangementATS 64)
                      ]
                ]
