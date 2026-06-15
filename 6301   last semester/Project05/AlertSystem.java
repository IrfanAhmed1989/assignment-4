import java.util.ArrayList;

public class AlertSystem {
    private NotificationMedium medium;
    private ArrayList<String> log = new ArrayList<>();

    public void setMedium(NotificationMedium medium) {
        this.medium = medium;
    }

    public void sendAlert(String message) {
        if (medium != null) {
            medium.send(message);
            log.add(message);
        }
    }

    public void showLogs() {
        System.out.println("Logs:");
        for (String msg : log) {
            System.out.println(msg);
        }
    }
}
