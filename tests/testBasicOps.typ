// Tests for AND, OR, NOT, IMPLIES (=>), XOR, and EQUIV (<=>).
// Row order (default):
//   1 variable (p):     (F), (T)
//   2 variables (p, q): (F,F), (T,F), (F,T), (T,T)
// sc step = bL + iL values per row; expression is the last iL slots.

#import "../src/main.typ": *
#set page(width: auto, height: auto)

// ── NOT ──────────────────────────────────────────────────────────────────────
// 1 var + 1 expr, step=2: expr at [1, 3]
// NOT(F)=T, NOT(T)=F

#let s-not = state("not-vals", ())
#let sc-not(v) = {
  s-not.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(sc: sc-not, $not p$)

#context {
  let v = s-not.get()
  assert(v.at(1) == true,  message: "NOT(F) should be T")
  assert(v.at(3) == false, message: "NOT(T) should be F")
}

// ── AND ──────────────────────────────────────────────────────────────────────
// 2 vars + 1 expr, step=3: expr at [2, 5, 8, 11]
// (F,F)=F (T,F)=F (F,T)=F (T,T)=T

#let s-and = state("and-vals", ())
#let sc-and(v) = {
  s-and.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(sc: sc-and, $p and q$)

#context {
  let v = s-and.get()
  assert(v.at(2)  == false, message: "AND(F,F) should be F")
  assert(v.at(5)  == false, message: "AND(T,F) should be F")
  assert(v.at(8)  == false, message: "AND(F,T) should be F")
  assert(v.at(11) == true,  message: "AND(T,T) should be T")
}

// ── OR ───────────────────────────────────────────────────────────────────────
// (F,F)=F (T,F)=T (F,T)=T (T,T)=T

#let s-or = state("or-vals", ())
#let sc-or(v) = {
  s-or.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(sc: sc-or, $p or q$)

#context {
  let v = s-or.get()
  assert(v.at(2)  == false, message: "OR(F,F) should be F")
  assert(v.at(5)  == true,  message: "OR(T,F) should be T")
  assert(v.at(8)  == true,  message: "OR(F,T) should be T")
  assert(v.at(11) == true,  message: "OR(T,T) should be T")
}

// ── IMPLIES ──────────────────────────────────────────────────────────────────
// p => q  ≡  ¬p ∨ q
// (F,F)=T (T,F)=F (F,T)=T (T,T)=T

#let s-imp = state("imp-vals", ())
#let sc-imp(v) = {
  s-imp.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(sc: sc-imp, $p => q$)

#context {
  let v = s-imp.get()
  assert(v.at(2)  == true,  message: "IMPLIES(F,F) should be T")
  assert(v.at(5)  == false, message: "IMPLIES(T,F) should be F")
  assert(v.at(8)  == true,  message: "IMPLIES(F,T) should be T")
  assert(v.at(11) == true,  message: "IMPLIES(T,T) should be T")
}

// ── XOR ──────────────────────────────────────────────────────────────────────
// (F,F)=F (T,F)=T (F,T)=T (T,T)=F

#let s-xor = state("xor-vals", ())
#let sc-xor(v) = {
  s-xor.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(sc: sc-xor, $p xor q$)

#context {
  let v = s-xor.get()
  assert(v.at(2)  == false, message: "XOR(F,F) should be F")
  assert(v.at(5)  == true,  message: "XOR(T,F) should be T")
  assert(v.at(8)  == true,  message: "XOR(F,T) should be T")
  assert(v.at(11) == false, message: "XOR(T,T) should be F")
}

// ── EQUIV ─────────────────────────────────────────────────────────────────────
// p <=> q  ≡  (p => q) ∧ (q => p)
// (F,F)=T (T,F)=F (F,T)=F (T,T)=T

#let s-eq = state("eq-vals", ())
#let sc-eq(v) = {
  s-eq.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(sc: sc-eq, $p <=> q$)

#context {
  let v = s-eq.get()
  assert(v.at(2)  == true,  message: "EQUIV(F,F) should be T")
  assert(v.at(5)  == false, message: "EQUIV(T,F) should be F")
  assert(v.at(8)  == false, message: "EQUIV(F,T) should be F")
  assert(v.at(11) == true,  message: "EQUIV(T,T) should be T")
}
