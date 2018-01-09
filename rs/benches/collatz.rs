#[macro_use]
extern crate criterion;
extern crate collatz;

use collatz::*;
use criterion::Criterion;

fn derangement_ramp(c: &mut Criterion) {
    c.bench_function("derangement-RAMP", |b| b.iter(|| derangements_ramp(64)));
}

fn derangement_gmp(c: &mut Criterion) {
    c.bench_function("derangement-GMP", |b| b.iter(|| derangements_gmp(64)));
}

fn derangement_bigint(c: &mut Criterion) {
    c.bench_function("derangement-bigint", |b| b.iter(|| derangements_bigint(64)));
}

fn collatz_2223(c: &mut Criterion) {
    c.bench_function("collatz (2223)", |b| b.iter(|| collatz_length(2223)));
}

fn collatz_10971(c: &mut Criterion) {
    c.bench_function("collatz (2223)", |b| b.iter(|| collatz_length(10971)));
}

fn collatz_106239(c: &mut Criterion) {
    c.bench_function("collatz (2223)", |b| b.iter(|| collatz_length(106239)));
}

criterion_group!(derangements, derangement_ramp, derangement_gmp, derangement_bigint);
criterion_group!(collatz, collatz_2223, collatz_10971, collatz_106239);
criterion_main!(derangements, collatz);
