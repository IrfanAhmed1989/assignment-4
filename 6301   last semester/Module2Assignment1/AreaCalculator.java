import java.util.Scanner;

/**
 * Purpose: Provides utility methods for geometric area calculations
 * and an interactive interface for user calculations.
 *
 * @author Irfan Ahmed
 * @version 1.0
 */
public class AreaCalculator {

    /**
     * Calculates the area of a rectangle.
     *
     * @param length The length of the rectangle
     * @param width The width of the rectangle
     * @return The area of the rectangle
     */
    public double calculateRectangleArea(double length, double width) {
        return length * width;
    }

    /**
     * Calculates the area of a triangle.
     *
     * @param base The base of the triangle
     * @param height The height of the triangle
     * @return The area of the triangle
     */
    public double calculateTriangleArea(double base, double height) {
        return (base * height) / 2;
    }

    /**
     * Main method to handle user interaction.
     *
     * @param args Command line arguments (not used)
     */
    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);
        AreaCalculator calc = new AreaCalculator();

        // Ask for name
        System.out.print("Please enter your name: ");
        String name = scanner.nextLine();

        // Menu
        System.out.println("Choose a shape:");
        System.out.println("Press 1 for Rectangle Area");
        System.out.println("Press 2 for Triangle Area");

        int choice = scanner.nextInt();

        double result = 0;

        if (choice == 1) {
            System.out.print("Enter length: ");
            double length = scanner.nextDouble();

            System.out.print("Enter width: ");
            double width = scanner.nextDouble();

            result = calc.calculateRectangleArea(length, width);

        } else if (choice == 2) {
            System.out.print("Enter base: ");
            double base = scanner.nextDouble();

            System.out.print("Enter height: ");
            double height = scanner.nextDouble();

            result = calc.calculateTriangleArea(base, height);

        } else {
            System.out.println("Invalid choice.");
            System.exit(0);
        }

        System.out.println("Hello " + name + ", the calculated area is: " + result);

        scanner.close();
    }
}
