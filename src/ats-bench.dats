#include "share/atspre_staload.hats"

#define ATS_MAINATSFLAG 1

%{$
int collatz_c(int n) {
  int l = 1;
  while (n != 1) {
    if (n % 2 == 0)
      n = n / 2;
    else
      n = 3 * n + 1;
    l++;
  }
  return l;
}
%}

fun collatz_length {n : nat} (n : int(n)) : int =
  let
    fnx loop {n : nat}{l : addr} (pf : !int @ l | n : int(n), res : ptr(l)) : void =
      if n > 1 then
        let
          val () = !res := 1 + !res
        in
          if n mod 2 = 0 then
            loop(pf | n / 2, res)
          else
            loop(pf | 3 * n + 1, res)
        end
    
    var res: int with pf = 1
    val () = loop(pf | n, addr@res)
  in
    res
  end

fun collatz_functional(n : int) : int =
  case+ n of
    | 1 => 1
    | x when n mod 2 = 0 => 1 + collatz_functional(x / 2)
    | x => 1 + collatz_functional(3 * x + 1)

fun collatz_stack_fun {n : nat} (n : int(n)) : int =
  let
    var g = fix@ f (x : int) : int => case+ x of
      | 1 => 1
      | n when x mod 2 = 0 => 1 + f(n / 2)
      | n => 1 + f(3 * n + 1)
  in
    g(n)
  end

extern
fun collatz_fs {n : nat} : int(n) -> int =
  "mac#"

implement collatz_fs (m) =
  collatz_stack_fun(m)

extern
fun collatz {n : nat} : int(n) -> int =
  "mac#"

implement collatz (m) =
  collatz_length(m)