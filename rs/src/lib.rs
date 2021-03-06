#![allow(unused_imports)]

extern crate num_bigint;
extern crate num_traits;
extern crate gmp;
extern crate ramp;

use ramp::Int;
use num_bigint::BigInt;
use num_traits::{Zero, One};
use std::mem::replace;
use gmp::mpz::Mpz;
use num_bigint::ToBigInt;

fn modular(a: i64, b: i64) -> i64 {
    ((a % b) + b) % b
}

pub fn factorial_ramp(n: u64) -> Int {
   let mut a = Int::from(1);

   for i in 2..n {
       a *= i;
   }

   a * n
}

pub fn factorial_gmp(n: i64) -> Mpz {
   let mut a = Mpz::from(1);

   for i in 2..n {
       a *= i;
   }

   a * n
}

pub fn factorial_bigint(n: i64) -> BigInt {
   let mut a: BigInt = One::one();

   for i in 2..n {
    a = a * i;
   }

   a * n
}

pub fn fibonacci_ramp(mut i: u64) -> Int {
    match i {
        0 => Int::from(1),
        1 => Int::from(1),
        _ => {
            let mut n1: Int = Int::from(1);
            let mut n0: Int = Int::from(1);
            while i != 0 {
                let n2 = n0 + &n1;
                n0 = replace(&mut n1, n2);
                i = i - 1;
            }
            n0
        }
    }
}

pub fn fibonacci_gmp(mut i: i64) -> Mpz {
    match i {
        0 => Mpz::from(1),
        1 => Mpz::from(1),
        _ => {
            let mut n1: Mpz = Mpz::from(1);
            let mut n0: Mpz = Mpz::from(1);
            while i != 0 {
                let n2 = n0 + &n1;
                n0 = replace(&mut n1, n2);
                i = i - 1;
            }
            n0
        }
    }
}

pub fn fibonacci_bigint(mut i: i64) -> BigInt {
    match i {
        0 => One::one(),
        1 => One::one(),
        _ => {
    let mut n1: BigInt = One::one();
    let mut n0: BigInt = One::one();
    while i != 0 {
        let n2 = n0 + &n1;
        n0 = replace(&mut n1, n2);
        i = i - 1;
    }
    n0
        }
    }
}

pub fn derangements_ramp(mut i: u64) -> Int {
    match i {
        0 => Int::from(1),
        1 => Int::from(0),
        _ => {
            let mut n1: Int = Int::from(0);
            let mut n0: Int = Int::from(1);
            while i != 0 {
                let n2 = (i - 1) * (n0 + &n1);
                n0 = replace(&mut n1, n2);
                i = i - 1;
            }
            n0
        }
    }
}

pub fn derangements_gmp(mut i: i64) -> Mpz {
    match i {
        0 => Mpz::from(1),
        1 => Mpz::from(0),
        _ => {
            let mut n1: Mpz = Mpz::from(0);
            let mut n0: Mpz = Mpz::from(1);
            while i != 0 {
                let n2 = (i - 1) * (n0 + &n1);
                n0 = replace(&mut n1, n2);
                i = i - 1;
            }
            n0
        }
    }
}

pub fn derangements_bigint(mut i: i64) -> BigInt {
    match i {
        0 => One::one(),
        1 => Zero::zero(),
        _ => {
    let mut n1: BigInt = Zero::zero();
    let mut n0: BigInt = One::one();
    while i != 0 {
        let n2 = (i - 1) * (n0 + &n1);
        n0 = replace(&mut n1, n2);
        i = i - 1;
    }
    n0
        }
    }
}

pub fn collatz_length(mut i: i64) -> i64 {
    let mut l = 1;
    while i != 1 {
        i = match modular(i, 2) {
            0 => i / 2,
            _ => 3 * i + 1,
        };
        l += 1;
    }
    l
}

#[test]
fn test_fibonacci_ramp() {
    let expected = Int::from(165580141);
    assert_eq!(fibonacci_ramp(40), expected);
}

#[test]
fn test_fibonacci_gmp() {
    let expected = Mpz::from(165580141);
    assert_eq!(fibonacci_gmp(40), expected);
}

#[test]
fn test_fibonacci_bigint() {
    let expected = ToBigInt::to_bigint(&165580141).unwrap();
    assert_eq!(fibonacci_bigint(40), expected);
}

#[test]
fn test_derangements_gmp() {
    let expected = Mpz::from(1334961);
    assert_eq!(derangements_gmp(10), expected);
}

#[test]
fn test_derangements_ramp() {
    let expected = Int::from(1334961);
    assert_eq!(derangements_ramp(10), expected);
}

#[test]
fn test_derangements_bigint() {
    let expected = ToBigInt::to_bigint(&1334961).unwrap();
    assert_eq!(derangements_bigint(10), expected);
}

#[test]
fn test_factorial_gmp() {
    let expected = Mpz::from(479001600);
    assert_eq!(factorial_gmp(12), expected);
}

#[test]
fn test_factorial_bigint() {
    let expected = ToBigInt::to_bigint(&479001600).unwrap();
    assert_eq!(factorial_bigint(12), expected);
}

#[test]
fn test_factorial_ramp() {
    let expected = Int::from(479001600);
    assert_eq!(factorial_ramp(12), expected);
}
