Module 3: Project #3 — Convert Python into Go
Author: Irfan Ahmed

Files:
- tribo.py                  : Original Python reference program provided in assignment.
- main.go                   : Go conversion that reproduces Python's exact behavior and output.
- tribonacci                : Built Go binary (darwin/arm64).
- expected_python_output.txt: Python output for n=20 (golden).
- go_output_20.txt          : Go output for n=20 (matches golden).
- bin_output_20.txt         : Binary output for n=20 (matches golden).
- py_out_*.txt              : Python outputs for edge cases [0,1,2,3,5,10,-5].
- go_out_*.txt              : Go outputs for the same edge cases.

How to run:
- Python:    python3 tribo.py
- Go (src):  go run main.go            # defaults to n=20
             go run main.go 10
- Go (bin):  ./tribonacci              # defaults to n=20
             ./tribonacci 10

Notes:
- Behavior parity with Python:
  - n <= 0 -> []
  - n == 1 -> [0]
  - n == 2 -> [0, 1]
  - n >= 3 -> sequence starts [1,1,1]; next term = sum of previous 3.
- Output formatting matches Python list print format exactly, including commas and spaces.
- Edge-case tests included and compared with diff; all matched.
