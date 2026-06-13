package uef.edu.vn.service;

import java.io.InputStream;
import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    private final Properties config = new Properties();
    private boolean enabled;

    public EmailService() {
        try (InputStream in = getClass().getClassLoader().getResourceAsStream("mail.properties")) {
            if (in != null) {
                config.load(in);
            }
            enabled = Boolean.parseBoolean(config.getProperty("mail.enabled", "false"));
        } catch (Exception e) {
            enabled = false;
        }
    }

    public void send(String to, String subject, String body) {
        if (!enabled) {
            System.out.println("[Email mock] To: " + to + " | " + subject + " | " + body);
            return;
        }
        try {
            Session session = Session.getInstance(config, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                            config.getProperty("mail.username"),
                            config.getProperty("mail.password"));
                }
            });
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(config.getProperty("mail.from")));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject, "UTF-8");
            message.setText(body, "UTF-8");
            Transport.send(message);
        } catch (Exception e) {
            System.err.println("Email send failed: " + e.getMessage());
        }
    }
}
