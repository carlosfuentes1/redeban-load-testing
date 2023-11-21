package helper;

import net.minidev.json.JSONObject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BDHandler{

//    private static final String URL = "jdbc:mysql://127.0.0.1:3306";
//    private static final String USER = "root";
//    private static final String PASSWORD = "1993";

    private static final String HOST = "jdbc:postgresql://localhost:1434/voucherdigital";
    private static final String USER = "voucherdigital";
    private static final String PASSWORD = "q&8SmrQrJ%nu";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(HOST, USER, PASSWORD);
    }

    public static JSONObject getData(int id) {
        JSONObject json = new JSONObject();
//        String sql = "SELECT * FROM sys.testautoo WHERE id = ?";
        String sql = "SELECT receipt_number, state FROM transaction_corresponsalia WHERE receipt_number = ?";
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, String.valueOf(id));
            ResultSet rs = statement.executeQuery();
            System.out.println("SQL ejecutado: " + sql);
            System.out.println("ID proporcionado: " + id);
            // Lista para almacenar todas las filas
            List<JSONObject> rows = new ArrayList<>();
            while (rs.next()) {
                JSONObject row = new JSONObject();
                row.put("receipt_number", rs.getString("receipt_number"));
                row.put("state", rs.getString("state"));
                rows.add(row);
            }
            // Almacenar la lista de filas en el objeto JSON
            json.put("rows", rows);
            // Imprimir el contenido del objeto JSON para propósitos de depuración
            System.out.println("Resultado JSON: " + json.toString());

            if (rows.isEmpty()) {
                // Handle the case where no data is found for the given id
                json.put("error", "No data found for the provided ID");
            }
        } catch (SQLException e) {
            // Handle SQLException appropriately, log it or throw a custom exception
            e.printStackTrace();
            json.put("error", "An error occurred while fetching data from the database" + e.getMessage());
        }
        return json;

    }
}
