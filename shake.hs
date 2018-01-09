#!/usr/bin/env stack
-- stack runghc --resolver lts-10.2 --package shake --install-ghc

import           Data.Maybe                 (fromMaybe)
import           Data.Monoid
import           Development.Shake
import           Development.Shake.FilePath
import           System.Exit                (ExitCode (..))
import           System.FilePath.Posix

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles=".shake" } $ do

    want [ "docs/criterion.html", "docs/derangement-RAMP.svg", "docs/derangement-GMP.svg", "docs/derangement-bigint.svg" ]

    "rs//*.svg" %> \_ -> do
        need ["rs/Cargo.toml", "rs/src/lib.rs", "rs/benches/collatz.rs"]
        command_ [Cwd "rs"] "cargo" ["bench"]

    "docs/*.svg" %> \out -> do
        let fileBase = dropExtension (dropDirectory1 out)
        let target = "rs/.criterion/" ++ fileBase ++ "/new/regression.svg"
        need [target]
        command_ [] "mv" [target, out]

    "hs/dist-newstyle/build/x86_64-linux/ghc-8.2.2/collatz-0.1.0.0/b/bench/opt/build/bench/bench" %> \_ -> do
        need ["hs/cbits/collatz.c", "hs/src/Lib.hs", "hs/Setup.hs", "hs/cabal.project.local", "hs/collatz.cabal"]
        path <- fromMaybe "" <$> getEnv "PATH"
        command_ [Cwd "hs", AddEnv "PATH" path, RemEnv "GHC_PACKAGE_PATH"] "cabal" ["new-build", "collatz:bench"]

    "docs/criterion.html" %> \out -> do
        need ["hs/cbits/collatz.c", "hs/dist-newstyle/build/x86_64-linux/ghc-8.2.2/collatz-0.1.0.0/b/bench/opt/build/bench/bench"]
        command [] "hs/dist-newstyle/build/x86_64-linux/ghc-8.2.2/collatz-0.1.0.0/b/bench/opt/build/bench/bench" ["--output", out]

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
        removeFilesAfter "rs/.criterion" ["//*"]
