/**
 * Concrete implementation of NotificationMedium for sending emails.
 *
 * @author Irfan
 */
public class EmailService implements NotificationMedium {

    /**
     * Default constructor for EmailService.
     */
    public EmailService() { }

    /**
     * Sends an email message.
     *
     * @param message The message to send via email
     */
    @Override
    public void send(String message) {
        System.out.println("Email sent: " + message);
    }
}
