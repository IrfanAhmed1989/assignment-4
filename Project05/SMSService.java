public class SMSService implements NotificationMedium {
    public void send(String message) {
        System.out.println("[SMS] Sending message: " + message);
    }
}
