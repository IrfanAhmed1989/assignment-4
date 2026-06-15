#!/usr/bin/env bash
set -euo pipefail

echo "==> Rebuild (safety)"
go build -o tribonacci

echo "==> Recompute Python golden for n=20"
python3 - << 'PY' | tee expected_python_output.txt >/dev/null
def tribonacci(n):
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    else:
        fib_seq = [1, 1, 1]
        for i in range(3, n):
            next_num = fib_seq[i-1] + fib_seq[i-2] + fib_seq[i-3]
            fib_seq.append(next_num)
        return fib_seq
print(tribonacci(20))
PY

echo "==> Run Go (source) n=20"
go run main.go | tee go_output_20.txt >/dev/null

echo "==> Run Go (binary) n=20"
./tribonacci | tee bin_output_20.txt >/dev/null

echo "==> Compare n=20"
diff -u expected_python_output.txt go_output_20.txt
diff -u expected_python_output.txt bin_output_20.txt

echo "==> Edge cases (recompute Python gold)"
python3 - << 'PY'
def tribonacci(n):
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    else:
        fib_seq = [1, 1, 1]
        for i in range(3, n):
            next_num = fib_seq[i-1] + fib_seq[i-2] + fib_seq[i-3]
            fib_seq.append(next_num)
        return fib_seq

for n in [0, 1, 2, 3, 5, 10, -5]:
    out = tribonacci(n)
    name = f"py_out_{n}.txt".replace("-", "neg")
    with open(name, "w") as f:
        f.write(str(out) + "\n")
    print(f"gold {n} -> {out}")
PY

echo "==> Edge cases (Go source)"
for n in 0 1 2 3 5 10 -5; do
  go run main.go "$n" > "go_out_${n}.txt"
  echo "go src $n -> $(cat "go_out_${n}.txt")"
done

echo "==> Compare edge cases"
for n in 0 1 2 3 5 10 -5; do
  if [ "$n" = "-5" ]; then left="py_out_neg5.txt"; else left="py_out_${n}.txt"; fi
  right="go_out_${n}.txt"
  diff -u "$left" "$right" && echo "$n MATCH ✅"
done

echo
echo "READY TO SUBMIT ✅"
