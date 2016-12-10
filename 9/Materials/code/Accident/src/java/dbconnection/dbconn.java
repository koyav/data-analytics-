package dbconnection;
import java.sql.*;
public class dbconn {
    public static Connection getconn()
    //public static void main(String arg[])
    {
    Connection con=null;
        try
        {

          Class.forName("com.mysql.jdbc.Driver");
          System.out.println("Driver Class Loaded");
          con=DriverManager.getConnection("jdbc:mysql://localhost:3306/accident","root","root");
          System.out.println("Connection Established");

        }
        catch(Exception e)
        {
            System.out.println(e);
        }
        return con;

}
}
