import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CheckQuizQuestionTable {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/icas";
        String username = "root";
        String password = "Ljw159357.";
        
        try {
            Connection conn = DriverManager.getConnection(url, username, password);
            DatabaseMetaData metaData = conn.getMetaData();
            
            System.out.println("=== quiz_question表结构 ===");
            ResultSet columns = metaData.getColumns(null, null, "quiz_question", null);
            while (columns.next()) {
                String columnName = columns.getString("COLUMN_NAME");
                String columnType = columns.getString("TYPE_NAME");
                int columnSize = columns.getInt("COLUMN_SIZE");
                System.out.println("字段名: " + columnName + ", 类型: " + columnType + ", 大小: " + columnSize);
            }
            
            System.out.println("\n=== quiz_question表数据 ===");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM quiz_question LIMIT 1");
            if (rs.next()) {
                System.out.println("ID: " + rs.getInt("id"));
                System.out.println("Quiz ID: " + rs.getInt("quiz_id"));
                System.out.println("Content类型: " + (rs.getObject("content") != null ? rs.getObject("content").getClass().getName() : "null"));
                System.out.println("Content值: " + rs.getString("content"));
                System.out.println("Type: " + rs.getString("type"));
                System.out.println("Option A: " + rs.getString("option_a"));
                System.out.println("Option B: " + rs.getString("option_b"));
                System.out.println("Option C: " + rs.getString("option_c"));
                System.out.println("Option D: " + rs.getString("option_d"));
                System.out.println("Correct Answer: " + rs.getString("correct_answer"));
                System.out.println("Score: " + rs.getInt("score"));
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
