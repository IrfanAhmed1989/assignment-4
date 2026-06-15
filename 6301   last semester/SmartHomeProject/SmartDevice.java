/**
 * Represents a generic smart device.
 *
 * @author Ahmed
 * @version 1.0
 */
public class SmartDevice {

    private String brand;
    private boolean powerOn;

    /**
     * Constructor to initialize device.
     *
     * @param brand The device brand
     */
    public SmartDevice(String brand) {
        this.brand = brand;
        this.powerOn = false;
    }

    /**
     * Toggles power state of device.
     *
     */
    public void togglePower() {
        powerOn = !powerOn;
        System.out.println("Power is now " + (powerOn ? "ON" : "OFF"));
    }

    /**
     * Gets brand name.
     *
     * @return brand
     */
    public String getBrand() {
        return brand;
    }

    /**
     * Checks power state.
     *
     * @return powerOn
     */
    public boolean isPowerOn() {
        return powerOn;
    }
}
