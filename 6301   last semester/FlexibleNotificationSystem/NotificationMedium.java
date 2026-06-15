/**
 * Interface representing a notification medium.
 * This allows different notification services to be used interchangeably.
 *
 * @author Irfan
 */
public interface NotificationMedium {

    /**
     * Sends a message using a specific medium.
     *
     * @param message The message to send
     */
    void send(String message);
}
