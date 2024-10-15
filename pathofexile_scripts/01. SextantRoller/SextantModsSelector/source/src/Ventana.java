import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Container;
import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.FlowLayout;

import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

public class Ventana extends JFrame implements ActionListener {
    private JCheckBox[] checkBoxes;
    private String path;
    private String pathSelected;

    public Ventana(String path, String pathSelected) throws IOException {
        super("Sextant selector");
        this.path = path;
        this.pathSelected = pathSelected;
    }

    public void run() throws IOException {
        Container cp = getContentPane();
        cp.setLayout(new BorderLayout());

        BufferedReader br = new BufferedReader(new FileReader(path));

        ArrayList<String> lines = new ArrayList<String>();
        String line;
        while ((line = br.readLine()) != null) {
            lines.add(line);
        }
        br.close();

        JPanel linePane = new JPanel(new GridLayout(lines.size(), 1, 10, 10));
        JScrollPane scrollabePane = new JScrollPane(linePane);
        scrollabePane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
        scrollabePane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);

        checkBoxes = new JCheckBox[lines.size()];
        for (int i = 0; i < checkBoxes.length; i++) {
            line = lines.get(i);
            checkBoxes[i] = new JCheckBox(line.replace(";", ""), line.contains(";"));
            linePane.add(checkBoxes[i]);
        }

        JPanel buttonPane = new JPanel(new FlowLayout());
        String[] stBtn = { "Save", "Select all", "Deselect all", "Create new file with selected" };
        for (int i = 0; i < stBtn.length; i++) {
            JButton btn = new JButton(stBtn[i]);
            btn.addActionListener(this);
            buttonPane.add(btn);
        }

        cp.add(scrollabePane, BorderLayout.CENTER);
        cp.add(buttonPane, BorderLayout.SOUTH);
        setSize(820, 400);
        // pack();

    }

    public void actionPerformed(ActionEvent e) {
        switch (e.getActionCommand()) {
            case "Save":
                saveSextants();
                break;
            case "Select all":
                selectAll();
                break;
            case "Deselect all":
                deselectAll();
                break;
            case "Create new file with selected":
                processSelected();
                break;

            default:
                break;
        }

    }

    private void processSelected() {
        saveSextants();
        try {
            BufferedReader br = new BufferedReader(new FileReader(path));
            String line;
            ArrayList<String> lines = new ArrayList<String>();
            while ((line = br.readLine()) != null) {
                if (line.contains(";")) {
                    lines.add(line.replace(";", ""));
                }
            }
            br.close();

            BufferedWriter bw = new BufferedWriter(new FileWriter(pathSelected));
            for (int i = 0; i < lines.size(); i++) {
                bw.append(lines.get(i));
                if (i != lines.size() - 1) {
                    bw.newLine();
                }
            }
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void saveSextants() {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(path))) {
            String line;
            for (int i = 0; i < checkBoxes.length; i++) {
                line = checkBoxes[i].getText();
                if (checkBoxes[i].isSelected()) {
                    line += ";";
                }
                bw.append(line);
                if (i != checkBoxes.length - 1) {
                    bw.newLine();
                }
            }
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void deselectAll() {
        for (int i = 0; i < checkBoxes.length; i++) {
            checkBoxes[i].setSelected(false);
        }
    }

    private void selectAll() {
        for (int i = 0; i < checkBoxes.length; i++) {
            checkBoxes[i].setSelected(true);
        }
    }
}