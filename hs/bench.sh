#!/usr/bin/env ion
export LD_LIBRARY_PATH=$(pwd)/ats:$LD_LIBRARY_PATH
cabal new-bench
