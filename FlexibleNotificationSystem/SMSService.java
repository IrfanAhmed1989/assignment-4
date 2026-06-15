/**
 * Concrete implementation of NotificationMedium for sending SMS messages.
 *
 * @author Irfan
 */
public class SMSService implements NotificationMedium {

    /**
     * Default constructor for SMSService.
     */
    public SMSService() { }

    /**
     * Sends an SMS message.
     *
     * @param message The message to send via SMS
     */
    @Override
    public void send(String message) {
        System.out.println("SMS sent: " + message);
    }
}
