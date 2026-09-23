import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TestQuizStatus {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/icas4";
        String username = "root";
        String password = "123456";
        
        try {
            Connection conn = DriverManager.getConnection(url, username, password);
            Statement stmt = conn.createStatement();
            
            System.out.println("=== 测验状态测试 ===");
            System.out.println("当前时间: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
            System.out.println();
            
            ResultSet rs = stmt.executeQuery("SELECT id, title, start_time, end_time, status FROM quiz");
            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                Timestamp startTime = rs.getTimestamp("start_time");
                Timestamp endTime = rs.getTimestamp("end_time");
                int status = rs.getInt("status");
                
                System.out.println("测验ID: " + id);
                System.out.println("标题: " + title);
                System.out.println("开始时间: " + startTime);
                System.out.println("结束时间: " + endTime);
                System.out.println("当前状态: " + status + " (0=未开始, 1=进行中, 2=已结束)");
                
                Date now = new Date();
                if (now.before(startTime)) {
                    System.out.println("预期状态: 0 (未开始)");
                } else if (now.after(endTime)) {
                    System.out.println("预期状态: 2 (已结束)");
                } else {
                    System.out.println("预期状态: 1 (进行中)");
                }
                System.out.println();
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
