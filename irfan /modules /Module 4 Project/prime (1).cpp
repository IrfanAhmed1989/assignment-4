#include <iostream>
using namespace std;

bool isPrime(int n) {
    if (n <= 1)                   return false;
    if (n <= 3)                   return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    for (int i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) return false;
    }
    return true;
}

int main() {
    int number;
    do {
        cout << "Enter a positive number (0 or negative to exit): ";
        cin >> number;
        if (number <= 0)     break;
        if (isPrime(number)) cout << number << " is a prime number." << endl;
        else                 cout << number << " is not a prime number." << endl;
    } while (true);
    return 0;
}

