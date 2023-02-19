#![allow(non_snake_case, unused_macros)]

use proconio::input;
use rand::prelude::*;

pub trait SetMinMax {
    fn setmin(&mut self, v: Self) -> bool;
    fn setmax(&mut self, v: Self) -> bool;
}
impl<T> SetMinMax for T
where
    T: PartialOrd,
{
    fn setmin(&mut self, v: T) -> bool {
        *self > v && {
            *self = v;
            true
        }
    }
    fn setmax(&mut self, v: T) -> bool {
        *self < v && {
            *self = v;
            true
        }
    }
}

#[macro_export]
macro_rules! mat {
	($($e:expr),*) => { Vec::from(vec![$($e),*]) };
	($($e:expr,)*) => { Vec::from(vec![$($e),*]) };
	($e:expr; $d:expr) => { Vec::from(vec![$e; $d]) };
	($e:expr; $d:expr $(; $ds:expr)+) => { Vec::from(vec![mat![$e $(; $ds)*]; $d]) };
}

pub const Q: usize = 100;
pub const MAX_N: usize = 100;

#[derive(Clone, Debug)]
pub struct Input {
    pub M: usize,
    pub eps: f64,
    pub ss: Vec<usize>,
    pub seed: u64,
}

impl std::fmt::Display for Input {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        writeln!(f, "{} {:.2}", self.M, self.eps)?;
        for i in 0..Q {
            writeln!(f, "{}", self.ss[i])?;
        }
        writeln!(f, "{}", self.seed)?;
        Ok(())
    }
}

pub fn parse_input(f: &str) -> Input {
    let f = proconio::source::once::OnceSource::from(f);
    input! {
        from f,
        M: usize, eps: f64,
        ss: [usize; Q],
        seed: u64,
    }
    Input { M, eps, seed, ss }
}

pub struct Output {
    pub N: usize,
    pub gs: Vec<String>,
    pub ts: Vec<usize>,
    pub comments: Vec<String>,
    pub comments_g: Vec<String>,
}

pub fn parse_output(input: &Input, f: &str) -> Result<Output, String> {
    let tokens = f.lines();
    let mut comment = String::new();
    let mut N = 0;
    let mut gs = vec![];
    let mut ts = vec![];
    let mut comments_g = vec![];
    let mut comments = vec![];
    for v in tokens {
        let v = v.trim();
        if v.len() == 0 {
            continue;
        } else if v.starts_with("#") {
            comment += v;
            comment.push('\n');
        } else if N == 0 {
            N = v.parse::<usize>().map_err(|_| format!("Illegal output (N): {}", v))?;
            if N < 4 || MAX_N < N {
                return Err(format!("Illegal output (N): {}", v));
            }
        } else if gs.len() < input.M {
            let cs = v.chars().collect::<Vec<_>>();
            if cs.len() != N * (N - 1) / 2 || cs.iter().any(|&c| c != '0' && c != '1') {
                return Err(format!("Illegal output (g_{}): {}", gs.len(), v));
            }
            gs.push(v.to_owned());
            comments_g.push(comment);
            comment = String::new();
        } else {
            let v = v
                .parse::<usize>()
                .map_err(|_| format!("Illegal output (t_{}): {}", ts.len(), v))?;
            if v < input.M {
                ts.push(v);
                comments.push(comment);
                comment = String::new();
            } else {
                return Err(format!("Illegal output (t_{}): {}", ts.len(), v));
            }
        }
    }
    Ok(Output {
        N,
        gs,
        ts,
        comments_g,
        comments,
    })
}

pub fn compute_score(input: &Input, out: &Output) -> i64 {
    let mut E = 0;
    for i in 0..Q {
        if input.ss[i] != out.ts[i] {
            E += 1;
        }
    }
    score(E, out.N)
}

pub fn score(E: i32, N: usize) -> i64 {
    (1e9 * f64::powi(0.9, E) / N as f64).round() as i64
}

pub fn gen(seed: u64, custom_M: Option<usize>, custom_eps: Option<f64>) -> Input {
    let mut rng = rand_chacha::ChaCha20Rng::seed_from_u64(seed ^ 275473);
    let mut M = rng.gen_range(10, 101i32) as usize;
    if let Some(M2) = custom_M {
        M = M2;
    }
    let mut eps = rng.gen_range(0, 41i32) as f64 * 0.01;
    if let Some(eps2) = custom_eps {
        eps = eps2;
    }
    let mut ss = vec![];
    for _ in 0..Q {
        ss.push(rng.gen_range(0, M as i32) as usize);
    }
    let seed = rng.gen::<u64>();
    Input { M, eps, ss, seed }
}
