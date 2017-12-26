#!/usr/bin/env stack
-- stack runghc --resolver lts-10.0 --package shake --install-ghc

import           Data.Maybe            (fromMaybe)
import           Data.Monoid
import           Development.Shake
import           System.Exit           (ExitCode (..))
import           System.FilePath.Posix

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles=".shake" } $ do

    want [ "hs/cbits/collatz.c" ]

    "hs/cbits/collatz.c" %> \out -> do
        cmd_ ["mkdir", "-p", "hs/cbits"]
        dats <- getDirectoryFiles "" ["//*.dats"]
        sats <- getDirectoryFiles "" ["//*.sats"]
        hats <- getDirectoryFiles "" ["//*.hats"]
        cats <- getDirectoryFiles "" ["//*.cats"]
        need $ dats <> sats <> hats <> cats
        need ["src/ats-bench.dats"]
        let patshome = "/usr/local/lib/ats2-postiats-0.3.8"
        (Exit c, Stderr err) <- command [EchoStderr False, AddEnv "PATSHOME" patshome] "patscc" ("-ccats" : dats)
        cmd_ [Stdin err] Shell "pats-filter"
        if c /= ExitSuccess
            then error "patscc failure"
            else pure ()
        cmd ["mv", "ats-bench_dats.c", "hs/cbits/collatz.c"]

    "clean" ~> do
        cmd_ ["sn", "c"]
        removeFilesAfter "." ["//*.c", "tags", "build"]
        removeFilesAfter ".shake" ["//*"]
