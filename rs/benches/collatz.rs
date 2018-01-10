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

fn fibonacci_ramp_bench(c: &mut Criterion) {
    c.bench_function("fibonacci-RAMP", |b| b.iter(|| fibonacci_ramp(50)));
}

fn fibonacci_gmp_bench(c: &mut Criterion) {
    c.bench_function("fibonacci-GMP", |b| b.iter(|| fibonacci_gmp(50)));
}

fn fibonacci_bigint_bench(c: &mut Criterion) {
    c.bench_function("fibonacci-bigint", |b| b.iter(|| fibonacci_bigint(50)));
}

fn factorial_ramp_bench(c: &mut Criterion) {
    c.bench_function("factorial-RAMP", |b| b.iter(|| factorial_ramp(50)));
}

fn factorial_gmp_bench(c: &mut Criterion) {
    c.bench_function("factorial-GMP", |b| b.iter(|| factorial_gmp(50)));
}

fn factorial_bigint_bench(c: &mut Criterion) {
    c.bench_function("factorial-bigint", |b| b.iter(|| factorial_bigint(50)));
}

criterion_group!(derangements, derangement_ramp, derangement_gmp, derangement_bigint);
criterion_group!(collatz, collatz_2223, collatz_10971, collatz_106239);
criterion_group!(fibonacci, fibonacci_ramp_bench, fibonacci_gmp_bench, fibonacci_bigint_bench);
criterion_group!(factorial, factorial_ramp_bench, factorial_gmp_bench, factorial_bigint_bench);
criterion_main!(derangements, collatz, fibonacci, factorial);
