import           Lib
import           Test.Hspec
import           Test.Hspec.QuickCheck

main :: IO ()
main = hspec $
    describe "collatzH" $
        parallel $ prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzH x == collatzPure x
