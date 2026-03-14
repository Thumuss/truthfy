// Tests for all `order` option combinations.
//
// The `order` string is a space-separated set of keywords:
//   "alphabetical"  — sort variables alphabetically before display
//   "reverse"       — reverse the variable column order
//   "textbook"      — rightmost variable increments fastest (binary counting)
//
// These can be combined: "alphabetical reverse", "alphabetical textbook", etc.
//
// ── How row order is determined ─────────────────────────────────────────────
// For each column col (1-based):
//   raised = "textbook" ? 2^(bL - col)  :  2^(col - 1)
//   value  = not even(floor(row / raised))
//
// sc fires as [col1_val, col2_val, expr_val] per row.
// For 2 variables + 1 expression: step = 3, indices per row k = [3k, 3k+1, 3k+2].
//

#import "../src/main.typ": *
#set page(width: auto, height: auto)

// ── 1. Default order ─────────────────────────────────────────────────────────
// base = [x, y]  (extraction order)
// col 1 → x, raised = 1  (x changes every row — fastest)
// col 2 → y, raised = 2  (y changes every 2 rows — slowest)
// Rows: (x=F,y=F), (x=T,y=F), (x=F,y=T), (x=T,y=T)
// x=>y:      T         F         T          T
// Expected state: [F,F,T, T,F,F, F,T,T, T,T,T]

#let s1 = state("order-default", ())
#let sc1(v) = { s1.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(sc: sc1, $x => y$)

#context {
  let v = s1.get()
  assert(v.at(0) == false, message: "default row0 col1: x=F")
  assert(v.at(1) == false, message: "default row0 col2: y=F")
  assert(v.at(2) == true,  message: "default row0 expr: F=>F=T")
  assert(v.at(3) == true,  message: "default row1 col1: x=T")
  assert(v.at(4) == false, message: "default row1 col2: y=F")
  assert(v.at(5) == false, message: "default row1 expr: T=>F=F")
  assert(v.at(6) == false, message: "default row2 col1: x=F")
  assert(v.at(7) == true,  message: "default row2 col2: y=T")
  assert(v.at(8) == true,  message: "default row2 expr: F=>T=T")
  assert(v.at(9)  == true, message: "default row3 col1: x=T")
  assert(v.at(10) == true, message: "default row3 col2: y=T")
  assert(v.at(11) == true, message: "default row3 expr: T=>T=T")
}

// ── 2. Textbook order ────────────────────────────────────────────────────────
// base = [x, y]  (unchanged)
// col 1 → x, raised = 2  (x changes every 2 rows — slowest)
// col 2 → y, raised = 1  (y changes every row — fastest)
// Rows: (x=F,y=F), (x=F,y=T), (x=T,y=F), (x=T,y=T)
// x=>y:      T         T         F          T
// Expected state: [F,F,T, F,T,T, T,F,F, T,T,T]
//
// This is the order requested in issue #19: rightmost variable increments fastest.

#let s2 = state("order-textbook", ())
#let sc2(v) = { s2.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "textbook", sc: sc2, $x => y$)

#context {
  let v = s2.get()
  assert(v.at(0) == false, message: "textbook row0 col1: x=F")
  assert(v.at(1) == false, message: "textbook row0 col2: y=F")
  assert(v.at(2) == true,  message: "textbook row0 expr: F=>F=T")
  assert(v.at(3) == false, message: "textbook row1 col1: x=F")
  assert(v.at(4) == true,  message: "textbook row1 col2: y=T")
  assert(v.at(5) == true,  message: "textbook row1 expr: F=>T=T")
  assert(v.at(6) == true,  message: "textbook row2 col1: x=T")
  assert(v.at(7) == false, message: "textbook row2 col2: y=F")
  assert(v.at(8) == false, message: "textbook row2 expr: T=>F=F")
  assert(v.at(9)  == true, message: "textbook row3 col1: x=T")
  assert(v.at(10) == true, message: "textbook row3 col2: y=T")
  assert(v.at(11) == true, message: "textbook row3 expr: T=>T=T")
}

// ── 3. Textbook with 3 variables ─────────────────────────────────────────────
// base = [x, y, z]; col 1→x (slowest), col 2→y, col 3→z (fastest)
// Rows: (F,F,F),(F,F,T),(F,T,F),(F,T,T),(T,F,F),(T,F,T),(T,T,F),(T,T,T)
// x AND y AND z: only T on the last row
// step = 4 per row (3 vars + 1 expr); expr at indices 3,7,11,15,19,23,27,31

#let s3 = state("order-textbook-3var", ())
#let sc3(v) = { s3.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "textbook", sc: sc3, $x and y and z$)

#context {
  let v = s3.get()
  // Verify column ordering: x slowest, z fastest
  assert(v.at(0) == false, message: "3var row0 x=F")
  assert(v.at(1) == false, message: "3var row0 y=F")
  assert(v.at(2) == false, message: "3var row0 z=F")
  assert(v.at(4) == false, message: "3var row1 x=F")
  assert(v.at(5) == false, message: "3var row1 y=F")
  assert(v.at(6) == true,  message: "3var row1 z=T")
  assert(v.at(8) == false, message: "3var row2 x=F")
  assert(v.at(9) == true,  message: "3var row2 y=T")
  assert(v.at(10) == false, message: "3var row2 z=F")
  assert(v.at(16) == true, message: "3var row4 x=T")
  assert(v.at(17) == false, message: "3var row4 y=F")
  assert(v.at(18) == false, message: "3var row4 z=F")
  // Verify expression values
  assert(v.at(3)  == false, message: "AND(F,F,F)=F")
  assert(v.at(7)  == false, message: "AND(F,F,T)=F")
  assert(v.at(11) == false, message: "AND(F,T,F)=F")
  assert(v.at(15) == false, message: "AND(F,T,T)=F")
  assert(v.at(19) == false, message: "AND(T,F,F)=F")
  assert(v.at(23) == false, message: "AND(T,F,T)=F")
  assert(v.at(27) == false, message: "AND(T,T,F)=F")
  assert(v.at(31) == true,  message: "AND(T,T,T)=T")
}

// ── 4. Reverse order ─────────────────────────────────────────────────────────
// base = [x, y] → reversed → [y, x]
// col 1 → y, raised = 1  (y changes every row — fastest)
// col 2 → x, raised = 2  (x changes every 2 rows — slowest)
// Rows: (y=F,x=F), (y=T,x=F), (y=F,x=T), (y=T,x=T)
// x=>y:      T         T         F          T
// Expected state: [F,F,T, T,F,T, F,T,F, T,T,T]

#let s4 = state("order-reverse", ())
#let sc4(v) = { s4.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "reverse", sc: sc4, $x => y$)

#context {
  let v = s4.get()
  assert(v.at(0) == false, message: "reverse row0 col1: y=F")
  assert(v.at(1) == false, message: "reverse row0 col2: x=F")
  assert(v.at(2) == true,  message: "reverse row0 expr: F=>F=T")
  assert(v.at(3) == true,  message: "reverse row1 col1: y=T")
  assert(v.at(4) == false, message: "reverse row1 col2: x=F")
  assert(v.at(5) == true,  message: "reverse row1 expr: F=>T=T")
  assert(v.at(6) == false, message: "reverse row2 col1: y=F")
  assert(v.at(7) == true,  message: "reverse row2 col2: x=T")
  assert(v.at(8) == false, message: "reverse row2 expr: T=>F=F")
  assert(v.at(9)  == true, message: "reverse row3 col1: y=T")
  assert(v.at(10) == true, message: "reverse row3 col2: x=T")
  assert(v.at(11) == true, message: "reverse row3 expr: T=>T=T")
}

// ── 5. Reverse textbook order ─────────────────────────────────────────────────
// base = [x, y] → reversed → [y, x]
// col 1 → y, raised = 2  (y changes every 2 rows — slowest)
// col 2 → x, raised = 1  (x changes every row — fastest)
// Rows: (y=F,x=F), (y=F,x=T), (y=T,x=F), (y=T,x=T)
// x=>y:      T         F         T          T
// Expected state: [F,F,T, F,T,F, T,F,T, T,T,T]

#let s5 = state("order-reverse-textbook", ())
#let sc5(v) = { s5.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "reverse textbook", sc: sc5, $x => y$)

#context {
  let v = s5.get()
  assert(v.at(0) == false, message: "rev+tb row0 col1: y=F")
  assert(v.at(1) == false, message: "rev+tb row0 col2: x=F")
  assert(v.at(2) == true,  message: "rev+tb row0 expr: F=>F=T")
  assert(v.at(3) == false, message: "rev+tb row1 col1: y=F")
  assert(v.at(4) == true,  message: "rev+tb row1 col2: x=T")
  assert(v.at(5) == false, message: "rev+tb row1 expr: T=>F=F")
  assert(v.at(6) == true,  message: "rev+tb row2 col1: y=T")
  assert(v.at(7) == false, message: "rev+tb row2 col2: x=F")
  assert(v.at(8) == true,  message: "rev+tb row2 expr: F=>T=T")
  assert(v.at(9)  == true, message: "rev+tb row3 col1: y=T")
  assert(v.at(10) == true, message: "rev+tb row3 col2: x=T")
  assert(v.at(11) == true, message: "rev+tb row3 expr: T=>T=T")
}

// ── 6. Alphabetical order ─────────────────────────────────────────────────────
// Using $b => a$ so extraction order [b, a] ≠ alphabetical order [a, b].
// base = [b, a] → sorted → [a, b]
// col 1 → a, raised = 1  (a changes every row — fastest)
// col 2 → b, raised = 2  (b changes every 2 rows — slowest)
// Rows: (a=F,b=F), (a=T,b=F), (a=F,b=T), (a=T,b=T)
// b=>a:      T         T         F          T
// Expected state: [F,F,T, T,F,T, F,T,F, T,T,T]

#let s6 = state("order-alphabetical", ())
#let sc6(v) = { s6.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "alphabetical", sc: sc6, $b => a$)

#context {
  let v = s6.get()
  assert(v.at(0) == false, message: "alpha row0 col1: a=F")
  assert(v.at(1) == false, message: "alpha row0 col2: b=F")
  assert(v.at(2) == true,  message: "alpha row0 expr: F=>F=T")
  assert(v.at(3) == true,  message: "alpha row1 col1: a=T")
  assert(v.at(4) == false, message: "alpha row1 col2: b=F")
  assert(v.at(5) == true,  message: "alpha row1 expr: F=>T=T")
  assert(v.at(6) == false, message: "alpha row2 col1: a=F")
  assert(v.at(7) == true,  message: "alpha row2 col2: b=T")
  assert(v.at(8) == false, message: "alpha row2 expr: T=>F=F")
  assert(v.at(9)  == true, message: "alpha row3 col1: a=T")
  assert(v.at(10) == true, message: "alpha row3 col2: b=T")
  assert(v.at(11) == true, message: "alpha row3 expr: T=>T=T")
}

// ── 7. Alphabetical textbook order ────────────────────────────────────────────
// base = [b, a] → sorted → [a, b]
// col 1 → a, raised = 2  (a changes every 2 rows — slowest)
// col 2 → b, raised = 1  (b changes every row — fastest)
// Rows: (a=F,b=F), (a=F,b=T), (a=T,b=F), (a=T,b=T)
// b=>a:      T         F         T          T
// Expected state: [F,F,T, F,T,F, T,F,T, T,T,T]

#let s7 = state("order-alphabetical-textbook", ())
#let sc7(v) = { s7.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "alphabetical textbook", sc: sc7, $b => a$)

#context {
  let v = s7.get()
  assert(v.at(0) == false, message: "alpha+tb row0 col1: a=F")
  assert(v.at(1) == false, message: "alpha+tb row0 col2: b=F")
  assert(v.at(2) == true,  message: "alpha+tb row0 expr: F=>F=T")
  assert(v.at(3) == false, message: "alpha+tb row1 col1: a=F")
  assert(v.at(4) == true,  message: "alpha+tb row1 col2: b=T")
  assert(v.at(5) == false, message: "alpha+tb row1 expr: T=>F=F")
  assert(v.at(6) == true,  message: "alpha+tb row2 col1: a=T")
  assert(v.at(7) == false, message: "alpha+tb row2 col2: b=F")
  assert(v.at(8) == true,  message: "alpha+tb row2 expr: F=>T=T")
  assert(v.at(9)  == true, message: "alpha+tb row3 col1: a=T")
  assert(v.at(10) == true, message: "alpha+tb row3 col2: b=T")
  assert(v.at(11) == true, message: "alpha+tb row3 expr: T=>T=T")
}

// ── 8. Alphabetical reverse order ─────────────────────────────────────────────
// base = [b, a] → sorted → [a, b] → reversed → [b, a]
// col 1 → b, raised = 1  (b changes every row — fastest)
// col 2 → a, raised = 2  (a changes every 2 rows — slowest)
// Rows: (b=F,a=F), (b=T,a=F), (b=F,a=T), (b=T,a=T)
// b=>a:      T         F         T          T
// Expected state: [F,F,T, T,F,F, F,T,T, T,T,T]

#let s8 = state("order-alphabetical-reverse", ())
#let sc8(v) = { s8.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "alphabetical reverse", sc: sc8, $b => a$)

#context {
  let v = s8.get()
  assert(v.at(0) == false, message: "alpha+rev row0 col1: b=F")
  assert(v.at(1) == false, message: "alpha+rev row0 col2: a=F")
  assert(v.at(2) == true,  message: "alpha+rev row0 expr: F=>F=T")
  assert(v.at(3) == true,  message: "alpha+rev row1 col1: b=T")
  assert(v.at(4) == false, message: "alpha+rev row1 col2: a=F")
  assert(v.at(5) == false, message: "alpha+rev row1 expr: T=>F=F")
  assert(v.at(6) == false, message: "alpha+rev row2 col1: b=F")
  assert(v.at(7) == true,  message: "alpha+rev row2 col2: a=T")
  assert(v.at(8) == true,  message: "alpha+rev row2 expr: F=>T=T")
  assert(v.at(9)  == true, message: "alpha+rev row3 col1: b=T")
  assert(v.at(10) == true, message: "alpha+rev row3 col2: a=T")
  assert(v.at(11) == true, message: "alpha+rev row3 expr: T=>T=T")
}

// ── 9. Alphabetical reverse textbook order ────────────────────────────────────
// base = [b, a] → sorted → [a, b] → reversed → [b, a]
// col 1 → b, raised = 2  (b changes every 2 rows — slowest)
// col 2 → a, raised = 1  (a changes every row — fastest)
// Rows: (b=F,a=F), (b=F,a=T), (b=T,a=F), (b=T,a=T)
// b=>a:      T         T         F          T
// Expected state: [F,F,T, F,T,T, T,F,F, T,T,T]

#let s9 = state("order-alphabetical-reverse-textbook", ())
#let sc9(v) = { s9.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(order: "alphabetical reverse textbook", sc: sc9, $b => a$)

#context {
  let v = s9.get()
  assert(v.at(0) == false, message: "alpha+rev+tb row0 col1: b=F")
  assert(v.at(1) == false, message: "alpha+rev+tb row0 col2: a=F")
  assert(v.at(2) == true,  message: "alpha+rev+tb row0 expr: F=>F=T")
  assert(v.at(3) == false, message: "alpha+rev+tb row1 col1: b=F")
  assert(v.at(4) == true,  message: "alpha+rev+tb row1 col2: a=T")
  assert(v.at(5) == true,  message: "alpha+rev+tb row1 expr: F=>T=T")
  assert(v.at(6) == true,  message: "alpha+rev+tb row2 col1: b=T")
  assert(v.at(7) == false, message: "alpha+rev+tb row2 col2: a=F")
  assert(v.at(8) == false, message: "alpha+rev+tb row2 expr: T=>F=F")
  assert(v.at(9)  == true, message: "alpha+rev+tb row3 col1: b=T")
  assert(v.at(10) == true, message: "alpha+rev+tb row3 col2: a=T")
  assert(v.at(11) == true, message: "alpha+rev+tb row3 expr: T=>T=T")
}
