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
fn bench_collatz_2223(b: &mut Bencher) {
    b.iter(|| collatz_length(2223));
}

fn modular(a: i64, b: i64) -> i64 {
    ((a % b) + b) % b
}
