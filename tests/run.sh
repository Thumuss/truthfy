#!/usr/bin/env bash
# Run all test*.typ files. Compilation failure = test failure.
# Usage: ./tests/run.sh  (from project root or tests/ directory)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PASS=0
FAIL=0

for f in "$SCRIPT_DIR"/test*.typ; do
  name="$(basename "$f")"
  out="$SCRIPT_DIR/${name%.typ}.pdf"
  if typst compile "$f" "$out" --root "$ROOT" 2>&1; then
    echo "PASS  $name"
    rm -f "$out"
    PASS=$((PASS + 1))
  else
    echo "FAIL  $name"
    FAIL=$((FAIL + 1))
  fi
done

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
