import javax.swing.JFrame;

public class App {
    public static void main(String[] args) throws Exception {
        String path = "sextants_all.txt";
        String pathSelected = "sextants_selected.txt";
        Ventana v = new Ventana(path, pathSelected);
        v.run();
        v.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        v.setLocationRelativeTo(null);
        v.setVisible(true);
    }
}
