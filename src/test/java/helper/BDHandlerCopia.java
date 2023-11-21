package helper;

import net.minidev.json.JSONObject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BDHandlerCopia {

//    private static final String URL = "jdbc:mysql://127.0.0.1:3306";
//    private static final String USER = "root";
//    private static final String PASSWORD = "1993";

    private static final String HOST = "jdbc:postgresql://localhost:1434/voucherdigital";
    private static final String USER = "voucherdigital";
    private static final String PASSWORD = "q&8SmrQrJ%nu";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(HOST, USER, PASSWORD);
    }

    //        String sql = "SELECT * FROM sys.testautoo WHERE id = ?";
//    String sql = "SELECT receipt_number, state FROM transaction_corresponsalia WHERE receipt_number = ?";

    public static void getData(int id) {
        String sql = String.format(Queries.query, String.valueOf(id), String.valueOf(id));
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet rs = statement.executeQuery();
            System.out.println("SQL ejecutado: " + sql);
            System.out.println("ID proporcionado: " + String.valueOf(id));

            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    String columnName = metaData.getColumnName(i);
                    Object value = rs.getObject(i);
                    System.out.println(columnName + ": " + value);
                }
                System.out.println("------------------------");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error: " + e.getMessage());
        }
    }


}
