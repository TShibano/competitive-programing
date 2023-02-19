#![allow(non_snake_case, unused_macros)]

use rand::prelude::*;
use proconio::{input, marker::*};
use svg::node::{element::{Circle, Path, Rectangle, path::Data, Line, Group, Title}, Text};

pub trait SetMinMax {
	fn setmin(&mut self, v: Self) -> bool;
	fn setmax(&mut self, v: Self) -> bool;
}
impl<T> SetMinMax for T where T: PartialOrd {
	fn setmin(&mut self, v: T) -> bool {
		*self > v && { *self = v; true }
	}
	fn setmax(&mut self, v: T) -> bool {
		*self < v && { *self = v; true }
	}
}

#[macro_export]
macro_rules! mat {
	($($e:expr),*) => { Vec::from(vec![$($e),*]) };
	($($e:expr,)*) => { Vec::from(vec![$($e),*]) };
	($e:expr; $d:expr) => { Vec::from(vec![$e; $d]) };
	($e:expr; $d:expr $(; $ds:expr)+) => { Vec::from(vec![mat![$e $(; $ds)*]; $d]) };
}

use std::cell::Cell;

#[derive(Clone, Debug)]
pub struct UnionFind {
	/// size / parent
	ps: Vec<Cell<usize>>,
	pub is_root: Vec<bool>
}

impl UnionFind {
	pub fn new(n: usize) -> UnionFind {
		UnionFind { ps: vec![Cell::new(1); n], is_root: vec![true; n] }
	}
	pub fn find(&self, x: usize) -> usize {
		if self.is_root[x] { x }
		else {
			let p = self.find(self.ps[x].get());
			self.ps[x].set(p);
			p
		}
	}
	pub fn unite(&mut self, x: usize, y: usize) {
		let mut x = self.find(x);
		let mut y = self.find(y);
		if x == y { return }
		if self.ps[x].get() < self.ps[y].get() {
			::std::mem::swap(&mut x, &mut y);
		}
		*self.ps[x].get_mut() += self.ps[y].get();
		self.ps[y].set(x);
		self.is_root[y] = false;
	}
	pub fn same(&self, x: usize, y: usize) -> bool {
		self.find(x) == self.find(y)
	}
	pub fn size(&self, x: usize) -> usize {
		self.ps[self.find(x)].get()
	}
}

pub type Output = Vec<char>;

const N: usize = 20;
const L: usize = 200;
const DIJ: [(usize, usize); 4] = [(!0, 0), (0, !0), (1, 0), (0, 1)];
const DIR: [char; 4] = ['U', 'L', 'D', 'R'];

#[derive(Clone, Debug)]
pub struct Input {
	s: (usize, usize),
	t: (usize, usize),
	p: f64,
	hs: Vec<Vec<bool>>,
	vs: Vec<Vec<bool>>,
}

impl Input {
	pub fn can_move(&self, i: usize, j: usize, d: usize) -> bool {
		match d {
			0 => i > 0 && !self.vs[i - 1][j],
			1 => j > 0 && !self.hs[i][j - 1],
			2 => i < N - 1 && !self.vs[i][j],
			3 => j < N - 1 && !self.hs[i][j],
			_ => unreachable!()
		}
	}
}

impl std::fmt::Display for Input {
	fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
		writeln!(f, "{} {} {} {} {:.2}", self.s.0, self.s.1, self.t.0, self.t.1, self.p)?;
		for i in 0..N {
			writeln!(f, "{}", self.hs[i].iter().map(|&a| if a { '1' } else { '0' }).collect::<String>())?;
		}
		for i in 0..N-1 {
			writeln!(f, "{}", self.vs[i].iter().map(|&a| if a { '1' } else { '0' }).collect::<String>())?;
		}
		Ok(())
	}
}

pub fn parse_input(f: &str) -> Input {
	let f = proconio::source::once::OnceSource::from(f);
	input! {
		from f,
		s: (usize, usize),
		t: (usize, usize),
		p: f64,
		hs: [Chars; N],
		vs: [Chars; N - 1],
	}
	let hs = hs.into_iter().map(|h| h.into_iter().map(|a| a == '1').collect()).collect();
	let vs = vs.into_iter().map(|v| v.into_iter().map(|a| a == '1').collect()).collect();
	Input { s, t, p, hs, vs }
}

pub fn parse_output(_input: &Input, f: &str) -> Result<Output, String> {
	Ok(f.trim().chars().collect())
}

pub fn compute_score(input: &Input, out: &[char]) -> (i64, String, Vec<Vec<f64>>) {
	let mut crt = mat![0.0; N; N];
	crt[input.s.0][input.s.1] = 1.0;
	let mut sum = 0.0;
	let mut goal = 0.0;
	for t in 0..out.len() {
		if t >= L {
			return (0, "too long output".to_owned(), crt);
		}
		if let Some(d) = DIR.iter().position(|&c| c == out[t]) {
			let mut next = mat![0.0; N; N];
			for i in 0..N {
				for j in 0..N {
					if crt[i][j] > 0.0 {
						if input.can_move(i, j, d) {
							let i2 = i + DIJ[d].0;
							let j2 = j + DIJ[d].1;
							next[i2][j2] += crt[i][j] * (1.0 - input.p);
							next[i][j] += crt[i][j] * input.p;
						} else {
							next[i][j] += crt[i][j];
						}
					}
				}
			}
			crt = next;
			sum += crt[input.t.0][input.t.1] * (2 * L - t) as f64;
			goal += crt[input.t.0][input.t.1];
			crt[input.t.0][input.t.1] = 0.0;
		} else {
			return (0, format!("illegal char: {}", out[t]), crt);
		}
	}
	crt[input.t.0][input.t.1] = goal;
	((1e8 * sum / (2 * L) as f64).round() as i64, String::new(), crt)
}

pub fn gen(seed: u64) -> Input {
	let mut rng = rand_chacha::ChaCha20Rng::seed_from_u64(seed ^ 16);
	let s = (rng.gen_range(0, 5i32) as usize, rng.gen_range(0, 5i32) as usize);
	let t = (rng.gen_range(N as i32 - 5, N as i32) as usize, rng.gen_range(N as i32 - 5, N as i32) as usize);
	let p = rng.gen_range(10i32, 51) as f64 / 100.0;
	let mut es = vec![];
	for i in 0..N {
		for j in 0..N {
			if i + 1 < N {
				es.push((i * N + j, (i + 1) * N + j));
			}
			if j + 1 < N {
				es.push((i * N + j, i * N + j + 1));
			}
		}
	}
	let mut hs = mat![true; N; N - 1];
	let mut vs = mat![true; N - 1; N];
	for _ in 0..2 {
		es.shuffle(&mut rng);
		let mut uf = UnionFind::new(N * N);
		for &(i, j) in &es {
			if !uf.same(i, j) {
				uf.unite(i, j);
				if i + 1 == j {
					hs[i / N][i % N] = false;
				} else {
					vs[i / N][i % N] = false;
				}
			}
		}
	}
	Input {
		s,
		t,
		p,
		hs,
		vs,
	}
}

fn rect(x: i32, y: i32, w: i32, h: i32, fill: &str) -> Rectangle {
	Rectangle::new().set("x", x).set("y", y).set("width", w).set("height", h).set("fill", fill)
}

pub fn vis(input: &Input, out: &[char], sample: Option<u64>) -> String {
	const W: usize = 40;
	let mut doc = svg::Document::new().set("id", "vis").set("viewBox", (-5, -5, W * N + 10, W * N + 10)).set("width", W * N + 10).set("height", W * N + 10);
	doc = doc.add(rect(-5, -5, (W * N + 10) as i32, (W * N + 10) as i32, "white"));
	let (_, _, ps) = compute_score(input, out);
	if sample.is_none() {
		for i in 0..N {
			for j in 0..N {
				doc = doc.add(Group::new().add(rect((j * W) as i32, (i * W) as i32, W as i32, W as i32, 	&format!("#{:02x}{:02x}{:02x}", 255, (255.0 * (1.0 - ps[i][j].sqrt())).round() as i32, (255.0 * (1.0 - ps[i][j].sqrt())).round() as i32)))
					.add(Title::new().add(Text::new(format!("({},{}) {:.2}%", i, j, ps[i][j] * 100.0)))));
			}
		}
	}
	doc = doc.add(Line::new().set("x1", 0).set("y1", 0).set("x2", W * N).set("y2", 0).set("stroke", "black")).set("stroke-width", 2);
	doc = doc.add(Line::new().set("x1", W * N).set("y1", 0).set("x2", W * N).set("y2", W * N).set("stroke", "black")).set("stroke-width", 2);
	doc = doc.add(Line::new().set("x1", W * N).set("y1", W * N).set("x2", 0).set("y2", W * N).set("stroke", "black")).set("stroke-width", 2);
	doc = doc.add(Line::new().set("x1", 0).set("y1", W * N).set("x2", 0).set("y2", 0).set("stroke", "black")).set("stroke-width", 2);
	for i in 0..N {
		for j in 0..N {
			if j + 1 < N && input.hs[i][j] {
				doc = doc.add(Line::new().set("x1", (j + 1) * W).set("y1", i * W).set("x2", (j + 1) * W).set("y2", (i + 1) * W).set("stroke", "black")).set("stroke-width", 2);
			}
			if i + 1 < N && input.vs[i][j] {
				doc = doc.add(Line::new().set("x1", j * W).set("y1", (i + 1) * W).set("x2", (j + 1) * W).set("y2", (i + 1) * W).set("stroke", "black")).set("stroke-width", 2);
			}
		}
	}
	for i in 1..N {
		for j in 1..N {
			doc = doc.add(Circle::new().set("cx", i * W).set("cy", j * W).set("r", 1).set("fill", "black"));
		}
	}
	if let Some(seed) = sample {
		let mut path = Data::new().move_to((input.s.1 * W + W / 2, input.s.0 * W + W / 2));
		let mut rng = rand_chacha::ChaCha20Rng::seed_from_u64(seed);
		let mut i = input.s.0;
		let mut j = input.s.1;
		for &c in out {
			if rng.gen_bool(input.p) {
				continue;
			}
			if let Some(d) = DIR.iter().position(|&c2| c2 == c) {
				if input.can_move(i, j, d) {
					i += DIJ[d].0;
					j += DIJ[d].1;
					path = path.line_to((j * W + W / 2, i * W + W / 2));
					if (i, j) == input.t {
						break;
					}
				}
			}
		}
		doc = doc.add(Path::new().set("d", path).set("fill", "none").set("stroke", "orange").set("stroke-width", 3).set("stroke-linecap", "round").set("stroke-linejoin", "round"));
	}
	doc = doc.add(Circle::new().set("cx", input.s.1 * W + W / 2).set("cy", input.s.0 * W + W / 2).set("r", 5).set("fill", "red"));
	doc = doc.add(Circle::new().set("cx", input.t.1 * W + W / 2).set("cy", input.t.0 * W + W / 2).set("r", 5).set("fill", "blue"));
	doc.to_string()
}
