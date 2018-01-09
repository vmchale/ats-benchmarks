import           Lib
import           Test.Hspec
import           Test.Hspec.QuickCheck

factorial :: Int -> Integer
factorial n = product [1..(fromIntegral n)]

main :: IO ()
main = hspec $ do
    parallel $ describe "collatzATS" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzATS x == collatzPure x
    parallel $ describe "collatzC" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzC x == collatzPure x
    parallel $ describe "derangement" $
        prop "should agree with the appropriate formula" $
            \n -> n < 1 || n > 18 || derangement n == floor ((fromIntegral (factorial n) :: Double) / (exp 1) + 0.5)
    parallel $ describe "derangementATS" $
        it "should agree with the pure Haskell function" $
            derangementATS 35 >>= (`shouldBe` derangement 35)
