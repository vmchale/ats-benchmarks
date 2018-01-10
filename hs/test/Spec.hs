import           Lib
import           Test.Hspec
import           Test.Hspec.QuickCheck

main :: IO ()
main = hspec $ parallel $ do
    describe "collatzATS" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzATS x == collatzPure x
    describe "collatzC" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzC x == collatzPure x
    describe "derangement" $
        prop "should agree with the appropriate formula" $
            \n -> n < 1 || n > 18 || derangement n == floor ((fromIntegral (factorial n :: Integer) :: Double) / (exp 1) + 0.5)
    describe "derangementATS" $
        it "should agree with the pure Haskell function for n=32" $
            derangementATS 32 >>= (`shouldBe` derangement 32)
    describe "fibonacciATS" $
        it "should agree with the pure Haskell function for n=50" $
            fibonacciATS 50 >>= (`shouldBe` fibonacci 50)
