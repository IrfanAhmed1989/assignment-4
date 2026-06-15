/**
 * Main class to test Smart Home system.
 *
 * @author Ahmed
 * @version 1.0
 */
public class Main {

    /**
     * Default constructor.
     */
    public Main() {
    }


    /**
     * Main method.
     *
     * @param args command line arguments
     */
    public static void main(String[] args) {

        SmartLight light = new SmartLight("Philips", 75);

        light.togglePower();
        light.connectToWiFi();
        light.setBrightness(90);

        System.out.println("Brightness: " + light.getBrightness());
        System.out.println("Brand: " + light.getBrand());
    }
}
