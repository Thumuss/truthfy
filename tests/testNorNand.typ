// Tests for NOR (↓) and NAND (↑) operators, including nested expressions.
// Row order (default, 2 vars x/y): (F,F), (T,F), (F,T), (T,T)
// sc fires on: x, y, expr1, expr2, expr3, expr4  →  step = 6 per row
// expr1 = x NOR y          → indices 2, 8, 14, 20
// expr2 = (x↓x)↓(y↓y)      → indices 3, 9, 15, 21  (equals x AND y)
// expr3 = x NAND y         → indices 4, 10, 16, 22
// expr4 = (x↑x)↑(y↑y)      → indices 5, 11, 17, 23  (equals x OR y)

#import "../src/main.typ": *
#set page(width: auto, height: auto)

#let nor  = math.arrow.b  // ↓
#let nand = math.arrow.t  // ↑

#let s = state("nor-nand-vals", ())
#let sc(v) = {
  s.update(a => a + (v,))
  if v { "1" } else { "0" }
}

#truth-table(
  sc: sc,
  $x nor y$,
  $(x nor x) nor (y nor y)$,
  $x nand y$,
  $(x nand x) nand (y nand y)$,
)

#context {
  let v = s.get()

  // ── x NOR y ──────────────────────────────────────────────────────────────
  assert(v.at(2)  == true,  message: "NOR(F,F) should be T")
  assert(v.at(8)  == false, message: "NOR(T,F) should be F")
  assert(v.at(14) == false, message: "NOR(F,T) should be F")
  assert(v.at(20) == false, message: "NOR(T,T) should be F")

  // ── (x↓x)↓(y↓y) = x AND y ───────────────────────────────────────────────
  assert(v.at(3)  == false, message: "nested-NOR(F,F) = AND(F,F) should be F")
  assert(v.at(9)  == false, message: "nested-NOR(T,F) = AND(T,F) should be F")
  assert(v.at(15) == false, message: "nested-NOR(F,T) = AND(F,T) should be F")
  assert(v.at(21) == true,  message: "nested-NOR(T,T) = AND(T,T) should be T")

  // ── x NAND y ─────────────────────────────────────────────────────────────
  assert(v.at(4)  == true,  message: "NAND(F,F) should be T")
  assert(v.at(10) == true,  message: "NAND(T,F) should be T")
  assert(v.at(16) == true,  message: "NAND(F,T) should be T")
  assert(v.at(22) == false, message: "NAND(T,T) should be F")

  // ── (x↑x)↑(y↑y) = x OR y ────────────────────────────────────────────────
  assert(v.at(5)  == false, message: "nested-NAND(F,F) = OR(F,F) should be F")
  assert(v.at(11) == true,  message: "nested-NAND(T,F) = OR(T,F) should be T")
  assert(v.at(17) == true,  message: "nested-NAND(F,T) = OR(F,T) should be T")
  assert(v.at(23) == true,  message: "nested-NAND(T,T) = OR(T,T) should be T")
}
