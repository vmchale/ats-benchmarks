#!/usr/bin/env stack
-- stack runghc --resolver nightly-2017-12-18 --package shake --install-ghc

import           Data.Maybe            (fromMaybe)
import           Data.Monoid
import           Development.Shake
import           System.Exit           (ExitCode (..))
import           System.FilePath.Posix

main :: IO ()
main = shakeArgs shakeOptions { shakeFiles=".shake" } $ do
    want [ "target/libcollatz.so", "hs/ats/libcollatz.so", "hs/ats/collatz.o", "hs/ats/collatz.c" ]

    "hs/ats//*" %> \out -> do
        let fname = takeFileName out
        need ["target/" ++ fname]
        cmd ["cp", "target/" ++ fname, out]

    "target/collatz.c" %> \out -> do
        need ["src/ats-bench.dats"]
        cmd_ ["patscc", "-ccats", "src/ats-bench.dats"]
        cmd ["mv", "ats-bench_dats.c", "target/collatz.c"]

    "target/libcollatz.so" %> \out -> do
        need ["target/collatz.o"]
        cmd ["gcc", "target/collatz.o", "-shared", "-o", out]

    "target/collatz.o" %> \out -> do
        dats <- getDirectoryFiles "" ["//*.dats"]
        sats <- getDirectoryFiles "" ["//*.sats"]
        hats <- getDirectoryFiles "" ["//*.hats"]
        cats <- getDirectoryFiles "" ["//*.cats"]
        need $ dats <> sats <> hats <> cats
        cmd_ ["mkdir", "-p", "target"]
        let patshome = "/usr/local/lib/ats2-postiats-0.3.8"
        let ccomp = "gcc -I/usr/local/lib/ats2-postiats-0.3.8/ccomp/runtime/ -I/usr/local/lib/ats2-postiats-0.3.8/ -fPIC -c"
        (Exit c, Stderr err) <- command [EchoStderr False, AddEnv "PATSHOME" patshome] "patscc" (dats ++ ["-atsccomp", ccomp, "-DATS_MEMALLOC_LIBC", "-o", out, "-O2", "-mtune=native"])
        cmd_ [Stdin err] Shell "pats-filter"
        if c /= ExitSuccess
            then error "patscc failure"
            else pure ()

    "clean" ~> do
        cmd_ ["sn", "c"]
        removeFilesAfter "." ["//*.c", "tags", "build"]
        removeFilesAfter ".shake" ["//*"]
        removeFilesAfter "target" ["//*"]
