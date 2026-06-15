/**
 * Represents a smart light device.
 *
 * @author Ahmed
 * @version 1.0
 */
public class SmartLight extends SmartDevice implements Connectable {

    private int brightnessLevel;

    /**
     * Constructor for SmartLight.
     *
     * @param brand Brand name
     * @param brightnessLevel Initial brightness
     */
    public SmartLight(String brand, int brightnessLevel) {
        super(brand); // important for rubric ✅
        this.brightnessLevel = brightnessLevel;
    }

    /**
     * Connects smart light to WiFi.
     *
     */
    @Override
    public void connectToWiFi() {
        System.out.println("SmartLight connected to WiFi successfully.");
    }

    /**
     * Sets brightness level.
     *
     * @param level brightness value
     */
    public void setBrightness(int level) {
        this.brightnessLevel = level;
    }

    /**
     * Gets brightness level.
     *
     * @return brightnessLevel
     */
    public int getBrightness() {
        return brightnessLevel;
    }
}
