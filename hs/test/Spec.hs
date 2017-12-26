import           Lib
import           Test.Hspec
import           Test.Hspec.QuickCheck

main :: IO ()
main = hspec $
    parallel $ describe "collatzStack" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzStack x == collatzPure x
