import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class CurrencyConverter {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Currency Converter");
        frame.setSize(400, 300);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JPanel panel = new JPanel();
        frame.add(panel);
        placeComponents(panel);

        frame.setVisible(true);
    }

    private static void placeComponents(JPanel panel) {
        panel.setLayout(null);

        JLabel fromLabel = new JLabel("From:");
        fromLabel.setBounds(10, 20, 80, 25);
        panel.add(fromLabel);

        String[] currencies = {"USD", "EUR", "INR"};
        JComboBox<String> fromCurrency = new JComboBox<>(currencies);
        fromCurrency.setBounds(100, 20, 165, 25);
        panel.add(fromCurrency);

        JLabel toLabel = new JLabel("To:");
        toLabel.setBounds(10, 50, 80, 25);
        panel.add(toLabel);

        JComboBox<String> toCurrency = new JComboBox<>(currencies);
        toCurrency.setBounds(100, 50, 165, 25);
        panel.add(toCurrency);

        JLabel amountLabel = new JLabel("Amount:");
        amountLabel.setBounds(10, 80, 80, 25);
        panel.add(amountLabel);

        JTextField amountText = new JTextField(20);
        amountText.setBounds(100, 80, 165, 25);
        panel.add(amountText);

        JButton convertButton = new JButton("Convert");
        convertButton.setBounds(10, 110, 80, 25);
        panel.add(convertButton);

        JLabel resultLabel = new JLabel("Result:");
        resultLabel.setBounds(10, 140, 300, 25);
        panel.add(resultLabel);

        convertButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try {
                    String from = (String) fromCurrency.getSelectedItem();
                    String to = (String) toCurrency.getSelectedItem();
                    double amount = Double.parseDouble(amountText.getText());
                    double rate = getExchangeRate(from, to);
                    double result = amount * rate;
                    resultLabel.setText("Result: " + result);
                } catch (NumberFormatException ex) {
                    resultLabel.setText("Invalid amount");
                }
            }
        });
    }

    private static double getExchangeRate(String fromCurrency, String toCurrency) {
        double rate = 1.0;
        if (fromCurrency.equals("USD") && toCurrency.equals("INR")) {
            rate = 75.0; // Example rate
        } else if (fromCurrency.equals("INR") && toCurrency.equals("USD")) {
            rate = 0.013; // Example rate
        }
        // Add more currency pairs as needed
        return rate;
    }
}
