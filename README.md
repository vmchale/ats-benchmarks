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
 $ ./shake.hs bench
```

and regenerate the data with:

```bash
 $ ./shake.hs bench --rebuild
```
