#!/usr/bin/env bash
set -euo pipefail

echo "=== MEGA TEST START — $(date) ==="

echo ""
echo "== Environment =="
python3 --version || true
go version || true
uname -a || true

echo ""
echo "== Clean & build =="
go mod tidy
gofmt -w main.go
go vet ./...
go build -o tribonacci

echo ""
echo "== n=20 exact format (Python vs Go src vs Go bin) =="
python3 tribo.py | tee py_20.txt >/dev/null
go run main.go | tee go_src_20.txt >/dev/null
./tribonacci | tee go_bin_20.txt >/dev/null
diff -u py_20.txt go_src_20.txt && echo "SRC FORMAT MATCH ✅" || { echo "SRC FORMAT MISMATCH ❌"; exit 1; }
diff -u py_20.txt go_bin_20.txt && echo "BIN FORMAT MATCH ✅" || { echo "BIN FORMAT MISMATCH ❌"; exit 1; }

echo ""
echo "== Parity sweep: 0..35 (source & binary) =="
for n in $(seq 0 35); do
  py="$(python3 - "$n" <<'PY'
import sys
n=int(sys.argv[1])
def tribonacci(n):
    if n <= 0: return []
    if n == 1: return [0]
    if n == 2: return [0, 1]
    s=[1,1,1]
    for i in range(3,n):
        s.append(s[i-1]+s[i-2]+s[i-3])
    return s
print(tribonacci(n))
PY
)"
  go_src="$(go run main.go "$n")"
  go_bin="$(./tribonacci "$n")"
  [ "$py" = "$go_src" ] || { echo "SRC DIFF at n=$n ❌"; echo "py=$py"; echo "go=$go_src"; exit 1; }
  [ "$py" = "$go_bin" ] || { echo "BIN DIFF at n=$n ❌"; echo "py=$py"; echo "bin=$go_bin"; exit 1; }
done
echo "0..35 ALL MATCH ✅"

echo ""
echo "== Edge cases & behavior =="
for arg in -5 -1 0 1 2 3 5 10 "" abc; do
  if [ -z "$arg" ]; then
    src="$(go run main.go)"
    bin="$(./tribonacci)"
    label="<no-arg>"
  else
    src="$(go run main.go "$arg" 2>/dev/null || true)"
    bin="$(./tribonacci "$arg" 2>/dev/null || true)"
    label="$arg"
  fi
  printf "ARG=%s | SRC=%s | BIN=%s\n" "$label" "$src" "$bin"
  # For <no-arg> and abc, compare to Python(20). For ints, compare to Python(n).
  if [ -z "$arg" ] || [ "$arg" = "abc" ]; then
    gold="$(python3 tribo.py)"
  else
    gold="$(python3 - "$arg" <<'PY'
import sys
n=int(sys.argv[1])
def tribonacci(n):
    if n <= 0: return []
    if n == 1: return [0]
    if n == 2: return [0, 1]
    s=[1,1,1]
    for i in range(3,n):
        s.append(s[i-1]+s[i-2]+s[i-3])
    return s
print(tribonacci(n))
PY
)"
  fi
  [ "$src" = "$gold" ] || { echo "SRC behavior mismatch for arg=$label ❌"; exit 1; }
  [ "$bin" = "$gold" ] || { echo "BIN behavior mismatch for arg=$label ❌"; exit 1; }
done
echo "Edge cases & behavior OK ✅"

echo ""
echo "== Stability check: repeat n=20 5x (src & bin) =="
for i in 1 2 3 4 5; do
  a="$(go run main.go)"
  b="$(./tribonacci)"
  [ "$a" = "$b" ] || { echo "Stability mismatch on iteration $i ❌"; exit 1; }
done
echo "Stability OK (5/5) ✅"

echo ""
echo "== Artifact hashes (n=20 outputs) =="
shasum -a 256 py_20.txt go_src_20.txt go_bin_20.txt || true

echo ""
echo "== Zip state (size, flags, checksum) =="
if [ -f Module3_Tribonacci_IrfanAhmed.zip ]; then
  ls -lO Module3_Tribonacci_IrfanAhmed.zip || true
  shasum -a 256 Module3_Tribonacci_IrfanAhmed.zip || true
else
  echo "Zip not found in this folder (OK if verifying in unpack)."
fi

echo ""
echo "=== MEGA TEST PASS ✅ — $(date) ==="
