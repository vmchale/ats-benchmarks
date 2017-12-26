#include "share/atspre_staload.hats"

#define ATS_MAINATSFLAG 1

fun collatz_length {n : nat} (n : int(n)) : int =
  let
    fnx loop {n : nat}{l : addr} (pf : !int @ l | n : int(n), res : ptr(l)) : void =
      if n > 1 then
        let
          val () = !res := 1 + !res
        in
          if g0int_mod(n, 2) = 0 then
            loop(pf | n / 2, res)
          else
            loop(pf | 3 * n + 1, res)
        end
    
    var res: int with pf = 1
    val () = loop(pf | n, addr@res)
  in
    res
  end

extern
fun collatz {n : nat} : int(n) -> int =
  "mac#"

implement collatz (m) =
  collatz_length(m)