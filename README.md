# ats-benchmarks

This is a repository for ATS benchmarks.

## Building

You will need to install [cargo](https://rustup.rs/),
[patscc](http://www.ats-lang.org/Downloads.html),
[pats-filter](https://github.com/Hibou57/PostiATS-Utilities),
[stack](https://haskellstack.org/),
[GHC](https://www.haskell.org/ghc/download.html), and
[cabal](https://www.haskell.org/cabal/download.html).

You can then generate benchmark data with:

```bash
 $ ./shake.hs
```

and regenerate the data with:

```bash
 $ ./shake.hs --rebuild
```

You can benchmark a specific task with one of:

```bash
 $ ./shake.hs collatz
 $ ./shake.hs fib
 $ ./shake.hs fact
 $ ./shake.hs derangement
```
