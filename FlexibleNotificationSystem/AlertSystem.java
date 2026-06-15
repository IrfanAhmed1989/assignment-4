import java.util.ArrayList;

/**
 * AlertSystem uses composition to delegate notification behavior.
 * It can switch notification mediums dynamically.
 *
 * @author Irfan
 */
public class AlertSystem {

    private NotificationMedium medium;
    private ArrayList<String> messageLog;

    /**
     * Constructor initializes message log.
     */
    public AlertSystem() {
        messageLog = new ArrayList<>();
    }

    /**
     * Sets the notification medium.
     *
     * @param medium The notification medium to use
     */
    public void setMedium(NotificationMedium medium) {
        this.medium = medium;
    }

    /**
     * Sends a notification using the current medium.
     *
     * @param message The message to send
     */
    public void notifyUser(String message) {
        if (medium != null) {
            medium.send(message);
            messageLog.add(message);
        } else {
            System.out.println("No notification medium set.");
        }
    }

    /**
     * Displays all logged messages.
     */
    public void showLog() {
        System.out.println("Message Log:");
        for (String msg : messageLog) {
            System.out.println(msg);
        }
    }

    /**
     * Main method to run the program.
     *
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        AlertSystem system = new AlertSystem();

        system.setMedium(new EmailService());
        system.notifyUser("Hello via Email!");

        system.setMedium(new SMSService());
        system.notifyUser("Hello via SMS!");

        system.showLog();
    }
}
