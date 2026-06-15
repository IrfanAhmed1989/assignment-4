
/*
 * Author: Irfan Ahmed
 * Course: Module 2 - Project #2 (Convert C++ into Java)
 * Environment: macOS Terminal using OpenJDK (javac/java)
 * Description:
 *   Java conversion of the provided C++ prime-checker.
 *   Behavior parity notes:
 *   - The original C++ reads into an int using `cin >> number`.
 *     For inputs like 3.7, C++ effectively uses 3. To reproduce the same
 *     observable behavior here, we read a double and cast to int (truncation).
 *   - Non-numeric tokens (e.g., "abc") cause C++ stream fail states; this Java
 *     version expects numeric input like your tests.
 */

import java.util.Scanner;

public class PrimeCheck {

    public static boolean isPrime(int n) {
        if (n <= 1)                   return false;
        if (n <= 3)                   return true;
        if (n % 2 == 0 || n % 3 == 0) return false;
        for (int i = 5; i * i <= n; i += 6) {
            if (n % i == 0 || n % (i + 2) == 0) return false;
        }
        return true;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int number;
        do {
            System.out.print("Enter a positive number (0 or negative to exit): ");
            // Read as double so inputs like 3.7 behave like C++ (become 3)
            double temp = sc.nextDouble();
            number = (int) temp; // truncates toward zero: 3.7 -> 3, -3.7 -> -3

            if (number <= 0) break;

            if (isPrime(number)) {
                System.out.println(number + " is a prime number.");
            } else {
                System.out.println(number + " is not a prime number.");
            }
        } while (true);

        sc.close();
    }
}
