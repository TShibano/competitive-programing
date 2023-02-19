#![allow(non_snake_case)]

use rand::prelude::*;
use std::io::{prelude::*, BufReader};
use std::process::{ChildStdout, Stdio};
use tools::*;

fn read(stdout: &mut BufReader<ChildStdout>) -> Result<String, String> {
    loop {
        let mut out = String::new();
        match stdout.read_line(&mut out) {
            Ok(0) | Err(_) => {
                return Err(format!("Your program has terminated unexpectedly"));
            }
            _ => (),
        }
        print!("{}", out);
        let v = out.trim();
        if v.len() == 0 || v.starts_with("#") {
            continue;
        }
        return Ok(v.to_owned());
    }
}

fn read_usize(stdout: &mut BufReader<ChildStdout>, lb: usize, ub: usize) -> Result<usize, String> {
    let v = read(stdout)?;
    let v = v.parse::<usize>().map_err(|_| format!("Illegal output: {}", v))?;
    if v < lb || ub < v {
        return Err(format!("Illegal output: {}", v));
    }
    Ok(v)
}

fn exec(p: &mut std::process::Child) -> Result<i64, String> {
    let mut input = String::new();
    std::io::stdin().read_to_string(&mut input).unwrap();
    let input = parse_input(&input);
    let mut stdin = std::io::BufWriter::new(p.stdin.take().unwrap());
    let mut stdout = std::io::BufReader::new(p.stdout.take().unwrap());
    let _ = writeln!(stdin, "{} {:.2}", input.M, input.eps);
    let _ = stdin.flush();
    let N = read_usize(&mut stdout, 4, MAX_N)?;
    let mut gs = vec![];
    for k in 0..input.M {
        let g = read(&mut stdout)?;
        let cs = g.chars().collect::<Vec<_>>();
        if cs.len() != N * (N - 1) / 2 || cs.iter().any(|&c| c != '0' && c != '1') {
            return Err(format!("Illegal output (g_{}): {}", k, g));
        }
        let mut g = mat![false; N; N];
        let mut p = 0;
        for i in 0..N {
            for j in i + 1..N {
                g[i][j] = cs[p] == '1';
                g[j][i] = g[i][j];
                p += 1;
            }
        }
        gs.push(g);
    }
    let mut rng = rand_chacha::ChaCha20Rng::seed_from_u64(input.seed);
    let mut E = 0;
    let mut result = String::new();
    for k in 0..Q {
        let mut vs = (0..N).collect::<Vec<_>>();
        vs.shuffle(&mut rng);
        let s = input.ss[k];
        let mut h = String::new();
        for i in 0..N {
            for j in i + 1..N {
                if gs[s][vs[i]][vs[j]] ^ rng.gen_bool(input.eps) {
                    h.push('1');
                } else {
                    h.push('0');
                }
            }
        }
        let _ = writeln!(stdin, "{}", h);
        let _ = stdin.flush();
        let t = read_usize(&mut stdout, 0, input.M - 1)?;
        if s != t {
            E += 1;
            result.push('x');
        } else {
            result.push('o');
        }
    }
    p.wait().unwrap();
    eprintln!("N = {}", N);
    eprintln!("E = {}", E);
    eprintln!("{}", result);
    Ok(score(E, N))
}

fn main() {
    if std::env::args().len() < 2 {
        eprintln!("Usage: {} <command> [<args>...]", std::env::args().nth(0).unwrap());
        return;
    }
    let (command, args) = (std::env::args().nth(1).unwrap(), std::env::args().skip(2).collect::<Vec<_>>());
    let mut p = std::process::Command::new(command)
        .args(args)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .unwrap_or_else(|e| {
            eprintln!("failed to execute the command");
            eprintln!("{}", e);
            std::process::exit(1)
        });
    match exec(&mut p) {
        Ok(score) => {
            eprintln!("Score = {}", score);
        }
        Err(err) => {
            let _ = p.kill();
            eprintln!("{}", err);
            eprintln!("Score = 0");
        }
    }
}
