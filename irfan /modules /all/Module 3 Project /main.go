/*
  Module 3: Project #3 — Convert Python into Go
  Author: Irfan Ahmed
  Notes:
    - This Go program replicates the exact behavior and printed output of the provided Python tribonacci implementation.
    - Behavior parity:
        tribonacci(n):
          n <= 0 -> []
          n == 1 -> [0]
          n == 2 -> [0, 1]
          n >= 3 -> starts with [1, 1, 1] and each next term is sum of previous 3.
    - Output formatting exactly matches Python's list print format: [a, b, c, ...]
    - If an integer argument is provided, the program prints tribonacci(<arg>).
      Otherwise, it prints tribonacci(20), matching the assignment's example.
*/

package main

import (
	"fmt"
	"os"
	"strconv"
)

func tribonacci(n int) []int {
	if n <= 0 {
		return []int{}
	} else if n == 1 {
		return []int{0}
	} else if n == 2 {
		return []int{0, 1}
	}

	seq := []int{1, 1, 1}
	for i := 3; i < n; i++ {
		next := seq[i-1] + seq[i-2] + seq[i-3]
		seq = append(seq, next)
	}
	return seq
}

// printPyList prints a Go slice to match Python's list formatting with commas and spaces.
func printPyList(seq []int) {
	fmt.Print("[")
	for i, v := range seq {
		if i > 0 {
			fmt.Print(", ")
		}
		fmt.Print(v)
	}
	fmt.Print("]")
}

func main() {
	// Default n is 20 to mirror the Python program's example.
	n := 20
	if len(os.Args) > 1 {
		if val, err := strconv.Atoi(os.Args[1]); err == nil {
			n = val
		} else {
			// If the arg isn't an int, keep default n=20.
		}
	}

	printPyList(tribonacci(n))
	fmt.Println()
}
