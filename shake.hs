#!/usr/bin/env stack
-- stack runghc --resolver lts-10.2 --package shake --install-ghc

import           Data.Maybe            (fromMaybe)
import           Data.Monoid
import           Development.Shake
import           System.Exit           (ExitCode (..))
import           System.FilePath.Posix

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles=".shake" } $ do

    want [ "hs/cbits/collatz.c" ]

    "hs/dist-newstyle/build/x86_64-linux/ghc-8.2.2/collatz-0.1.0.0/b/bench/opt/build/bench/bench" %> \_ -> do
        need ["hs/cbits/collatz.c", "hs/src/Lib.hs", "hs/Setup.hs", "hs/cabal.project.local", "hs/collatz.cabal"]
        path <- fromMaybe "" <$> getEnv "PATH"
        command_ [Cwd "hs", AddEnv "PATH" path, RemEnv "GHC_PACKAGE_PATH"] "cabal" ["new-build", "collatz:bench"]

    "docs/criterion.html" %> \out -> do
        need ["hs/cbits/collatz.c", "hs/dist-newstyle/build/x86_64-linux/ghc-8.2.2/collatz-0.1.0.0/b/bench/opt/build/bench/bench"]
        command [] "hs/dist-newstyle/build/x86_64-linux/ghc-8.2.2/collatz-0.1.0.0/b/bench/opt/build/bench/bench" ["--output", out]

    "bench" ~> do
        need ["docs/criterion.html"]
        command_ [Cwd "rs"] "cargo" ["bench"]

    "ci" ~> do
        need ["hs/cbits/collatz.c"]
        cmd_ ["tomlcheck", "--file", ".atsfmt.toml"]
        cmd_ ["yamllint", "hs/stack.yaml"]
        cmd_ ["hlint", "hs"]
        path <- fromMaybe "" <$> getEnv "PATH"
        command_ [Cwd "hs", AddEnv "PATH" path, RemEnv "GHC_PACKAGE_PATH"] "cabal" ["new-test"]

    "hs/cbits/collatz.c" %> \out -> do
        cmd_ ["mkdir", "-p", "hs/cbits"]
        dats <- getDirectoryFiles "" ["//*.dats"]
        sats <- getDirectoryFiles "" ["//*.sats"]
        hats <- getDirectoryFiles "" ["//*.hats"]
        cats <- getDirectoryFiles "" ["//*.cats"]
        need $ dats <> sats <> hats <> cats
        let patshome = "/usr/local/lib/ats2-postiats-0.3.8"
        (Exit c, Stderr err) <- command [EchoStderr False, AddEnv "PATSHOME" patshome] "patscc" ("-ccats" : dats)
        cmd_ [Stdin err] Shell "pats-filter"
        if c /= ExitSuccess
            then error "patscc failure"
            else pure ()
        cmd ["mv", "ats-bench_dats.c", "hs/cbits/collatz.c"]

    "clean" ~> do
        cmd_ ["sn", "c"]
        removeFilesAfter "." ["//*.c", "//tags", "build"]
        removeFilesAfter ".shake" ["//*"]
        removeFilesAfter "docs" ["//*"]
