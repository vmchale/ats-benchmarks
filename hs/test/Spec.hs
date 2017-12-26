import           Lib
import           Test.Hspec
import           Test.Hspec.QuickCheck

main :: IO ()
main = hspec $ do
    parallel $ describe "collatzStack" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzStack x == collatzPure x
    parallel $ describe "collatzC" $
        prop "should agree with the pure Haskell function" $
            \x -> x < 1 || collatzC x == collatzPure x
