// CSC6033 – Project P#1
// Dot product of two integer vectors
// Author: IRFAN AHMED
// Course: CSC6033 Languages, Automata, and Decidability – Week 1
//
// Requirements covered (per project statement):
//  • A function that performs the dot product of two vectors received each as
//    a single-dimension pointer, plus the number of elements for both vectors.
//  • The function receives exactly three input parameters:
//      - first vector (pointer to int)
//      - second vector (pointer to int)
//      - number of elements for both vectors (int n)
//  • The function returns the numerical (integer) dot product result.
//  • Nothing is printed inside the dot-product function; only main prints.
//  • The driver (main) creates the vectors, calls the function, and prints the result.
//
// Notes:
//  - This program prints ONLY the numerical results (one per line) to strictly
//    match the examples in the assignment description.
//  - Example vectors used are the two shown by the instructor.

#include <iostream>
using namespace std;

// Computes the dot product of two integer vectors of the same length.
// Parameters:
//   v1, v2 : pointers to the first elements of the input integer arrays
//   n      : number of elements in both vectors (assumed equal)
// Returns:
//   The integer dot product sum_{i=0..n-1} v1[i] * v2[i]
// Contract: does not print anything (per spec).
int dot_product(const int* v1, const int* v2, int n) {
    int acc = 0;
    for (int i = 0; i < n; ++i) {
        acc += v1[i] * v2[i];
        // Alternative using pointer arithmetic (equivalent):
        // acc += *(v1 + i) * *(v2 + i);
    }
    return acc;
}

int main() {
    // --- Example 1 ---
    int a1[] = {8, 16, 32};
    int b1[] = {5, 9, 13};
    int n1 = static_cast<int>(sizeof(a1) / sizeof(a1[0]));

    int r1 = dot_product(a1, b1, n1);
    cout << r1 << "\n";  // Expected: 600

    // --- Example 2 ---
    int a2[] = {3, 8};
    int b2[] = {11, 22};
    int n2 = static_cast<int>(sizeof(a2) / sizeof(a2[0]));

    int r2 = dot_product(a2, b2, n2);
    cout << r2 << "\n";  // Expected: 209

    return 0; // indicate successful run
}
