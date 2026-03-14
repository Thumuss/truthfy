// Tests for custom column headers.
//
// Each expression column can optionally carry a display override:
//   (eq: $<math>$, display: [<anything>])
// The `eq` field drives computation; `display` is shown in the header.
// Plain math expressions (no dict) continue to work unchanged.

#import "../src/main.typ": *
#set page(width: auto, height: auto)

// ── Custom display header ─────────────────────────────────────────────────────
// Computation is still $A and B$; header shows condensed notation $A B$.
// Values must match plain AND: (F,F)=F, (T,F)=F, (F,T)=F, (T,T)=T

#let s1 = state("custom-header-vals", ())
#let sc1(v) = { s1.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(
  sc: sc1,
  (eq: $A and B$, display: $A B$),
)

#context {
  let v = s1.get()
  // 2 vars + 1 expr, step = 3; expr at [2, 5, 8, 11]
  assert(v.at(2)  == false, message: "custom header AND(F,F) should be F")
  assert(v.at(5)  == false, message: "custom header AND(T,F) should be F")
  assert(v.at(8)  == false, message: "custom header AND(F,T) should be F")
  assert(v.at(11) == true,  message: "custom header AND(T,T) should be T")
}

// ── Mixed: one custom header, one plain ───────────────────────────────────────
// First column uses display override; second uses plain expression.
// Values: AND and OR side by side.

#let s2 = state("mixed-header-vals", ())
#let sc2(v) = { s2.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(
  sc: sc2,
  (eq: $p and q$, display: $p q$),
  $p or q$,
)

#context {
  let v = s2.get()
  // 2 vars + 2 exprs, step = 4; AND at [2,6,10,14], OR at [3,7,11,15]
  assert(v.at(2)  == false, message: "mixed AND(F,F) should be F")
  assert(v.at(6)  == false, message: "mixed AND(T,F) should be F")
  assert(v.at(10) == false, message: "mixed AND(F,T) should be F")
  assert(v.at(14) == true,  message: "mixed AND(T,T) should be T")

  assert(v.at(3)  == false, message: "mixed OR(F,F) should be F")
  assert(v.at(7)  == true,  message: "mixed OR(T,F) should be T")
  assert(v.at(11) == true,  message: "mixed OR(F,T) should be T")
  assert(v.at(15) == true,  message: "mixed OR(T,T) should be T")
}

// ── display defaults to eq when omitted ───────────────────────────────────────
// Passing only `eq` (no `display`) should behave identically to passing the
// math expression directly.

#let s3 = state("eq-only-vals", ())
#let sc3(v) = { s3.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table(sc: sc3, (eq: $p and q$))

#context {
  let v = s3.get()
  assert(v.at(2)  == false, message: "eq-only AND(F,F) should be F")
  assert(v.at(5)  == false, message: "eq-only AND(T,F) should be F")
  assert(v.at(8)  == false, message: "eq-only AND(F,T) should be F")
  assert(v.at(11) == true,  message: "eq-only AND(T,T) should be T")
}

// ── truth-table-empty: custom header ─────────────────────────────────────────
// _gen-nb-left-empty-truth iterates columns in reverse (rng.rev()), so for
// bL=2 the sc fires as [col2_val, col1_val, data_val] per row.
// With base=[p,q]: col2→p (raised=2, slow), col1→q (raised=1, fast).
// Row order: (p=F,q=F), (p=F,q=T), (p=T,q=F), (p=T,q=T)
// step = 3 (2 vars + 1 data col); data at [2, 5, 8, 11]
// AND data: F, F, F, T

#let s4 = state("empty-custom-header-vals", ())
#let sc4(v) = { s4.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table-empty(
  sc: sc4,
  ((eq: $p and q$, display: $p q$),),
  (false, false, false, true),
)

#context {
  let v = s4.get()
  // Variable columns
  assert(v.at(0) == false, message: "empty row0 p=F")
  assert(v.at(1) == false, message: "empty row0 q=F")
  assert(v.at(3) == false, message: "empty row1 p=F")
  assert(v.at(4) == true,  message: "empty row1 q=T")
  assert(v.at(6) == true,  message: "empty row2 p=T")
  assert(v.at(7) == false, message: "empty row2 q=F")
  // Data values come from the supplied array, not from eq evaluation
  assert(v.at(2)  == false, message: "empty AND(F,F) should be F")
  assert(v.at(5)  == false, message: "empty AND(F,T) should be F")
  assert(v.at(8)  == false, message: "empty AND(T,F) should be F")
  assert(v.at(11) == true,  message: "empty AND(T,T) should be T")
}

// ── truth-table-empty: mixed dict + plain ────────────────────────────────────
// One column uses a custom header dict, one uses a plain expression.
// step = 4 (2 vars + 2 data cols); AND at [2,6,10,14], OR at [3,7,11,15]
// Data interleaved as [AND_r0, OR_r0, AND_r1, OR_r1, ...]

#let s5 = state("empty-mixed-header-vals", ())
#let sc5(v) = { s5.update(a => a + (v,)); if v {"1"} else {"0"} }

#truth-table-empty(
  sc: sc5,
  ((eq: $p and q$, display: $p q$), $p or q$),
  (false, false,
   false, true,
   false, true,
   true,  true),
)

#context {
  let v = s5.get()
  assert(v.at(2)  == false, message: "empty mixed AND(F,F) should be F")
  assert(v.at(6)  == false, message: "empty mixed AND(F,T) should be F")
  assert(v.at(10) == false, message: "empty mixed AND(T,F) should be F")
  assert(v.at(14) == true,  message: "empty mixed AND(T,T) should be T")

  assert(v.at(3)  == false, message: "empty mixed OR(F,F) should be F")
  assert(v.at(7)  == true,  message: "empty mixed OR(F,T) should be T")
  assert(v.at(11) == true,  message: "empty mixed OR(T,F) should be T")
  assert(v.at(15) == true,  message: "empty mixed OR(T,T) should be T")
}
