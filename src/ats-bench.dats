#include "share/atspre_staload.hats"
#include "contrib/atscntrb-hx-intinf/mylibies.hats"
#include "contrib/atscntrb-libgmp/mylibies.hats"

#define ATS_MAINATSFLAG 1

staload UN = "prelude/SATS/unsafe.sats"
staload "contrib/atscntrb-hx-intinf/SATS/intinf_vt.sats"
staload "contrib/atscntrb-libgmp/SATS/gmp.sats"

vtypedef mpz = $GMP.mpz_vt0ype

%{$
// mpz fib_c(int n) {
//  mpz_fib_ui(n)

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

fun fib_quick(n : int) : Intinf =
  let
    val z = ptr_alloc<mpz>()
    val x: ulint = g0int2uint_int_ulint(n + 1)
    val () = $GMP.mpz_init(!(z.2))
    val () = mpz_fib_uint(!(z.2), x)
  in
    $UN.castvwtp0(z)
  end

fnx factorial_big {n : nat} .<n>. (k : int(n)) : Intinf =
  case+ k of
    | 0 => int2intinf(1)
    | k =>> mul_intinf0_int(factorial_big(k - 1), k)

fn fib {n : nat} (n : int(n)) : Intinf =
  let
    fnx loop { n : nat | n > 1 }{i : nat} .<max(0,n-i)>. ( n : int(n)
                                                         , i : int(i)
                                                         , n1 : Intinf
                                                         , n2 : Intinf
                                                         ) : Intinf =
      if i < n then
        let
          var x = add_intinf0_intinf1(n2, n1)
        in
          loop(n, i + 1, x, n1)
        end
      else
        let
          var x = add_intinf0_intinf1(n2, n1)
          val _ = intinf_free(n1)
        in
          x
        end
  in
    case+ n of
      | 0 => int2intinf(1)
      | 1 =>> int2intinf(1)
      | 2 =>> int2intinf(2)
      | n =>> loop(n - 1, 2, int2intinf(2), int2intinf(1))
  end

fn derangements {n : nat} (n : int(n)) : Intinf =
  let
    fnx loop { n : nat | n > 1 }{ i : nat | i <= n } .<n-i>. ( n : int(n)
                                                             , i : int(i)
                                                             , n1 : Intinf
                                                             , n2 : Intinf
                                                             ) : Intinf =
      if i < n then
        let
          var x = add_intinf0_intinf1(n2, n1)
          var y = mul_intinf0_int(x, i)
        in
          loop(n, i + 1, y, n1)
        end
      else
        let
          var x = add_intinf0_intinf1(n2, n1)
          val _ = intinf_free(n1)
          var y = mul_intinf0_int(x, i)
        in
          y
        end
  in
    case+ n of
      | 0 => int2intinf(1)
      | 1 =>> int2intinf(0)
      | 2 =>> int2intinf(1)
      | n =>> loop(n - 1, 2, int2intinf(1), int2intinf(0))
  end

fun collatz_sequence(n : intGt(0)) : stream_vt(int) =
  case+ n of
    | 1 => $ldelay(stream_vt_cons(1, $ldelay(stream_vt_nil)))
    | n when n % 2 = 0 =>> $ldelay(stream_vt_cons(n, collatz_sequence(n / 2)))
    | n =>> $ldelay(stream_vt_cons(n, collatz_sequence(3 * n + 1)))

fun collatz_length_stream(n : intGt(0)) : int =
  stream_vt_length(collatz_sequence(n))

fun collatz_length {n : nat} (n : int(n)) : int =
  let
    fnx loop {n : nat}{l : addr} (pf : !int @ l | n : int(n), res : ptr(l)) : void =
      if n > 1 then
        let
          val () = !res := 1 + !res
        in
          if n % 2 = 0 then
            loop(pf | n / 2, res)
          else
            loop(pf | 3 * n + 1, res)
        end
    
    var res: int with pf = 1
    val () = loop(pf | n, addr@res)
  in
    res
  end

fun collatz_functional(n : int) :<!ntm> int =
  case+ n of
    | 1 => 1
    | x when n % 2 = 0 => 1 + collatz_functional(x / 2)
    | x => 1 + collatz_functional(3 * x + 1)

fun collatz_stack_fun {n : nat} (n : int(n)) : int =
  let
    var g = fix@ f (x : int) : int => case+ x of
      | 1 => 1
      | n when x % 2 = 0 => 1 + f(n / 2)
      | n => 1 + f(3 * n + 1)
  in
    g(n)
  end

extern
fun collatz_fs {n : nat} : int(n) -> int =
  "mac#"

extern
fun factorial_ats_big {n : nat} : int(n) -> Intinf =
  "mac#"

extern
fun derangement_ats {n : nat} : int(n) -> Intinf =
  "mac#"

extern
fun fib_ats {n : nat} : int(n) -> Intinf =
  "mac#"

extern
fun fib_gmp {n : nat} : int(n) -> Intinf =
  "mac#"

extern
fun collatz : intGt(0) -> int =
  "mac#"

implement factorial_ats_big (n) =
  factorial_big(n)

implement collatz_fs (m) =
  collatz_stack_fun(m)

implement derangement_ats (m) =
  derangements(m)

implement fib_ats (m) =
  fib(m)

implement fib_gmp (m) =
  fib_quick(m)

implement collatz (m) =
  collatz_length(m)