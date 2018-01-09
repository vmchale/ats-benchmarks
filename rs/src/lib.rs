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

pub fn factorial(mut i: i64) -> i64 {
    let mut l = 1;
    while i != 0 {
        l = l * i;
        i = i - 1;
    }
    l
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
fn test_factorial() {
    let expected = 6227020800;
    assert_eq!(factorial(13), expected);
}
