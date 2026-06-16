public class MainApp {
    public static void main(String[] args) {

        AlertSystem alert = new AlertSystem();

        // Email
        alert.setMedium(new EmailService());
        alert.sendAlert("Hello via Email");

        // SMS
        alert.setMedium(new SMSService());
        alert.sendAlert("Hello via SMS");

        // WhatsApp
        alert.setMedium(new WhatsAppService());
        alert.sendAlert("Hello via WhatsApp");

        alert.showLogs();
    }
}
