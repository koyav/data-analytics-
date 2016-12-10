<%@ page import="dbconnection.*,java.sql.*" %>
<%
Connection con=dbconn.getconn();
Statement st=con.createStatement();
String qry1="delete from dataset2";
st.executeUpdate(qry1);
PreparedStatement psmt1=dbconn.getconn().prepareStatement("select year,avg(weathercondition),sum(noofaccidents) from dataset1 group by year");
ResultSet rs=psmt1.executeQuery();
while(rs.next())
{
    String qry="insert into dataset2 values('"+rs.getInt(1)+"','"+rs.getInt(2)+"','"+rs.getInt(3)+"')";
    System.out.println("insert into dataset2 values('"+rs.getInt(1)+"','"+rs.getInt(2)+"','"+rs.getInt(3)+"')");
    Statement stmt=con.createStatement();
    stmt.executeUpdate(qry);
}    
%>
<%
PreparedStatement psmt2=dbconn.getconn().prepareStatement("select * from dataset2");
ResultSet rs1=psmt2.executeQuery();
%>
<html>
    <head><link rel="stylesheet" href="Style.css"/></head>
 <body>
<div id="div1">
<hr>
<h1 align="center">DataSet</h1>
<hr>
<br>

<a href="regression.jsp"><input type="button" value="Linear Regression"></a>

<br>
<br>
<table align="center"  width="30%">
    <tr><th>Year</th><th>Weather Conditions</th><th>No of Accidents</th></tr>
    <% while(rs1.next()) { %>
    <tr><td align="center"><%= rs1.getInt(1) %> </td><td align="center"><%= rs1.getInt(2) %> </td><td align="center"><%= rs1.getInt(3) %> </td></tr>
    <% } %>
</table>
</div>
    </body>
</html>