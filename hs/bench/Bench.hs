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
                , bgroup "factorial (large)"
                      [ bench "Haskell 50" $ nf (factorial :: Int -> Integer) 50
                      , bench "ATS 50" $ nfIO (factorialATS 50)
                      ]
                , bgroup "fibonacci"
                      [ bench "fibonacci (50)" $ nf fibonacci 50
                      , bench "fibonacciATS (50)" $ nfIO (fibonacciATS 50)
                      ]
                , env envFileRead $ \ n ->
                  bgroup "derangement"
                      [ bench "derangement (64)" $ nf derangement n
                      , bench "id (96800425246141091510518408809597121)" $ nf id (96800425246141091510518408809597121 :: Integer)
                      , bench "derangementATS (64)" $ nfIO (derangementATS n)
                      ]
                ]
        where envFileRead = read <$> readFile "hs/scrap"
