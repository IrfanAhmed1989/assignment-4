#!/usr/bin/env bash
set -euo pipefail

NS=(-5 0 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35)

echo "==> Rebuild (safety)"
go build -o tribonacci

echo "==> Verify default behavior equals n=20 (source & bin)"
py20="$(python3 - << 'PY'
def tribonacci(n):
    if n <= 0:
        return []
    if n == 1:
        return [0]
    if n == 2:
        return [0, 1]
    seq = [1,1,1]
    for i in range(3,n):
        seq.append(seq[i-1]+seq[i-2]+seq[i-3])
    return seq
print(tribonacci(20))
PY
)"
gos="$(go run main.go)"
gob="$(./tribonacci)"
if [[ "$gos" != "$py20" ]]; then echo "DEFAULT (src) DIFF ❌"; echo "  py20: $py20"; echo "  gos : $gos"; exit 1; else echo "DEFAULT (src) MATCH ✅"; fi
if [[ "$gob" != "$py20" ]]; then echo "DEFAULT (bin) DIFF ❌"; echo "  py20: $py20"; echo "  gob : $gob"; exit 1; else echo "DEFAULT (bin) MATCH ✅"; fi

echo "==> Verify non-integer arg falls back to default n=20"
gos_abc="$(go run main.go abc || true)"
gob_abc="$(./tribonacci abc || true)"
if [[ "$gos_abc" != "$py20" ]]; then echo "NON-INT ARG (src) DIFF ❌"; exit 1; else echo "NON-INT ARG (src) MATCH ✅"; fi
if [[ "$gob_abc" != "$py20" ]]; then echo "NON-INT ARG (bin) DIFF ❌"; exit 1; else echo "NON-INT ARG (bin) MATCH ✅"; fi

echo "==> Deep loop over Ns: ${NS[*]}"
for n in "${NS[@]}"; do
  py="$(python3 - "$n" << 'PY'
import sys
n = int(sys.argv[1])
def tribonacci(n):
    if n <= 0:
        return []
    if n == 1:
        return [0]
    if n == 2:
        return [0, 1]
    seq = [1,1,1]
    for i in range(3,n):
        seq.append(seq[i-1]+seq[i-2]+seq[i-3])
    return seq
print(tribonacci(n))
PY
)"
  go_src="$(go run main.go "$n")"
  go_bin="$(./tribonacci "$n")"

  if [[ "$py" != "$go_src" ]]; then
    echo "n=$n (src) DIFF ❌"
    echo "  py : $py"
    echo "  go : $go_src"
    exit 1
  fi
  if [[ "$py" != "$go_bin" ]]; then
    echo "n=$n (bin) DIFF ❌"
    echo "  py : $py"
    echo "  go : $go_bin"
    exit 1
  fi
  echo "n=$n MATCH ✅"
done

echo
echo "DEEP TESTS PASS ✅"
