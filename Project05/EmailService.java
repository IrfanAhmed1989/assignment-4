public class EmailService implements NotificationMedium {
    public void send(String message) {
        System.out.println("[Email] Sending message: " + message);
    }
}
