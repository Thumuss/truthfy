<center>

# 🧠 Truthfy

**Generate truth tables effortlessly — manual or automatic.**
</center>

`Truthfy` makes it easy to generate **truth tables** and **Karnaugh maps** with minimal Typst code.
Whether you're a student, a teacher, or just dabbling in logic, Truthfy helps you visualize logic expressions — fast and clean and write your papers effortlessly.

---

## ✨ What You Can Do

- 📋 Generate truth tables — pre-filled or empty
- 🧩 Create empty Karnaugh maps
- 🎨 Customize how 0 and 1 are displayed by using <a href="#sc">`Symbol Convention`</a>
- 🔃 Reverse, reorder, align your rows, anything you want!

---

## 🔧 Quick Functions

```typst
#let truth-table(..info: array[math_block]): table
```
➡️ Create a **filled** truth table from logical expressions.

```typst
#let truth-table-empty(info: array[math_block], data: array[str]): table
```
➡️ Create an **empty** table — or fill it manually.

```typst
#let karnaugh-empty(info: array[math_block], data: array[str]): table
```
➡️ Build an empty Karnaugh map.

Special symbols:
- `NAND`: like `sym.arrow.t`
- `NOR`: like `sym.arrow.b`

---

## 🛠 Options You Can Use

<div id="sc"/>

### 🔣 `sc`: Symbol Convention
Customize how `0` and `1` are rendered:

```typst
#let sc(symb) = {
  if (symb) { // It's 1!
    "✅"
  } else { // It's 0!
    "❌"
  }
}
```
Use it like:
```typst
#truth-table(sc: sc, $A and B$)
```

### 🔁 `reverse`
Flip your truth table from bottom to top.

### 🔠 `order`
Control the order of variable evaluation:
- `"alphabetical"`
- `"reverse"`
- `"textbook"` (classic logic order)

### 📐 `align`
Align your table columns with Typst's native [table guide](https://typst.app/docs/guides/table-guide/#alignment).

---

## 🚀 Get Started — In Seconds

```typst
#import "@preview/truthfy:0.7.0": truth-table

#truth-table($A and B$, $A or B$, $A => B$, $A xor B$)
```

🖼️ Output:
![Example](https://github.com/Thumuss/truthfy/assets/42680097/7edb921d-659e-4348-a12a-07bcc3822012)

Want something fancier?
```typst
#truth-table(sc: (x) => if x {"✔"} else {"✘"}, $a and b$)
```

Or go manual:
```typst
#truth-table-empty(sc: (x) => if x {"1"} else {"0"},
  ($a and b$,),
  (false, [], true)
)
```

🖼️ Output:
![Custom Symbols](https://github.com/Thumuss/truthfy/assets/42680097/1ccf6077-5cfb-4643-b621-1dc9529b8176)

🔎 See the [examples/](/examples) directory for full samples.

---

## 🧑‍💻 Contributing

### Project layout

```
src/
  main.typ          # Package source — all logic lives here
examples/
  basicExamples.typ         # General usage examples
  logicSymbolsExample.typ   # NOR / NAND and custom symbol examples
tests/
  testNorNand.typ   # Assertion tests for NOR and NAND (direct and nested)
  testBasicOps.typ  # Assertion tests for AND, OR, NOT, IMPLIES, XOR, EQUIV
  testOrder.typ     # Assertion tests for all ordering options
  run.sh            # Test runner script
justfile              # just commands (see below)
```

### ⚡ just commands

Install [`just`](https://github.com/casey/just) and then run any of these from the project root:

| Command | Description |
|---|---|
| `just tests` | Compile every `tests/test_*.typ` file and assert correctness |
| `just examples` | Compile all example files to PDF |
| `just ci` | Run `tests` then `examples` — useful before opening a PR |
| `just clean` | Delete all generated PDFs in `examples/` and `tests/` |
| `just watch <file>` | Live-recompile a file on save, e.g. `just watch examples/basicExamples.typ` |

### 🧪 How tests work

Each test file in `tests/` passes a custom `sc` callback to `truth-table` that accumulates the computed boolean values into a Typst `state`. A `context` block at the end of the file reads the collected values and calls `assert` on each one. If any assertion fails, `typst compile` exits with a non-zero code and prints the failing message — no external test framework needed.

To add a new test, create a `tests/test<name>.typ` file following the same pattern and it will be picked up automatically by `just tests`.

New idea? Bug found? Head over to [Issues](https://github.com/Thumuss/truthfy/issues) and let's improve Truthfy together.

---

## 📜 Changelog Highlights

### `0.7.0`
- Fixed evaluation of nested NOR / NAND expressions ✅

### `0.6.0`
- Support for `->` in math mode ✅
- Better math expression parsing 📚
- New `order` option 🧮

### Earlier...
- `karnaugh-empty` support
- `sc` for customizing symbols
- Better examples, visuals, and reversed tables

---

**Truthfy** — *For logic lovers, learners, and Typst tinkerers.*

