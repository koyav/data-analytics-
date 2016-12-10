<%@ page import="dbconnection.*,java.sql.*" %>
<%
PreparedStatement psmt1=dbconn.getconn().prepareStatement("select * from dataset1 order by year asc");
ResultSet rs=psmt1.executeQuery();
%>
<html>
    <head><link rel="stylesheet" href="Style.css"/></head>
 <body>
<div id="div1">
<hr>
<h1 align="center">Accident DataSet</h1>
<hr>
<br>
<a href="dataset1.jsp"><input type="button" value="Grouping Year Wise"></a>
<br>
<br>
<table align="center"  width="30%">
    <tr><th>Year</th><th>Weather Conditions</th><th>No of Accidents</th></tr>
    <% while(rs.next()) { %>
    <tr><td align="center"><%= rs.getInt(1) %> </td><td align="center"><%= rs.getInt(2) %> </td><td align="center"><%= rs.getInt(3) %> </td></tr>
    <% } %>
</table>
</div>
    </body>
</html>