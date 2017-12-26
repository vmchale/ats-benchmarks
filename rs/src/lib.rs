#![feature(test)]

#![allow(unused_imports)]
extern crate test;

use test::test::Bencher;

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

#[bench]
fn bench_collatz(b: &mut Bencher) {
    let constant = 10971;
    b.iter(|| collatz_length(constant));
}

fn modular(a: i64, b: i64) -> i64 {
    ((a % b) + b) % b
}
