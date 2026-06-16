/**
 * WhatsAppService implements NotificationMedium
 * to send alerts via WhatsApp.
 */
public class WhatsAppService implements NotificationMedium {

    /**
     * Sends a message via WhatsApp.
     * @param message the message to send
     */
    public void send(String message) {
        System.out.println("[WhatsApp] Sending message: " + message);
    }
}
