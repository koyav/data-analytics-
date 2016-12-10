<%@ page import="dbconnection.*,java.sql.*" %>
<%
int m1=0,m2=0;
float b1=0.0f,b0=0.0f;
float y=0.0f;
Connection con=dbconn.getconn();
Statement stmt4=con.createStatement();
String qry="delete from calculation";
stmt4.executeUpdate(qry);
Statement stmt1=con.createStatement();
String qry1="select * from dataset2";
ResultSet rs=stmt1.executeQuery(qry1);
Statement stmt2=con.createStatement();
String qry2="select avg(weathercondition) from dataset2";
ResultSet rs1=stmt2.executeQuery(qry2);
if(rs1.next())
{
    m1=rs1.getInt(1);
    System.out.println(m1);
}  
Statement stmt3=con.createStatement();
String qry3="select avg(noofaccidents) from dataset2";
ResultSet rs2=stmt3.executeQuery(qry3);
if(rs2.next())
{
    m2=rs2.getInt(1);
    System.out.println(m2);
}  
%>
<html>
    <head><link rel="stylesheet" href="Style.css"/></head>
 <body>
<div id="div1">
<hr>
<h1 align="center">DataSet</h1>
<hr>
<br>
<a href="dataset.jsp"><input type="button" value="Home"></a>
<br><br>
<br>
<br>
<table align="center"  width="80%">
  <tr>
      <th>Year</th>
      <th>Weather Condition (Xi)</th>
      <th>No of Accidents (Yi)</th>
      <th>(Xi-M1)</th>
      <th>(Yi-M2)</th>
      <th>POW((Xi-M1),2)</th>
      <th>POW((Yi-M2),2)</th>
      <th>(Xi-M1)*(Yi-M2)</th>
  </tr>
<% 
while(rs.next()) 
{
%>
 <tr>
     <td><%= rs.getInt(1) %> </td>
     <td><%= rs.getInt(2) %> </td>
     <td><%= rs.getInt(3) %> </td>
     <td><%= ((rs.getInt(2))-m1) %> </td>
     <td><%= ((rs.getInt(3))-m2) %> </td>
     <td><%=((rs.getInt(2))-m1)*((rs.getInt(2))-m1)%></td>
     <td><%=((rs.getInt(3))-m2)*((rs.getInt(3))-m2)%></td>
     <td><%=((rs.getInt(2))-m1)*((rs.getInt(3))-m2)%></td>  
<%
Statement st=con.createStatement();
String q="insert into calculation values('"+((rs.getInt(2))-m1)+"','"+((rs.getInt(3))-m2)+"','"+((rs.getInt(2))-m1)*((rs.getInt(2))-m1)+"','"+((rs.getInt(3))-m2)*((rs.getInt(3))-m2)+"','"+((rs.getInt(2))-m1)*((rs.getInt(3))-m2)+"')";
st.executeUpdate(q);
%>    
 </tr>
<% } %>
</table>


<%
Statement s=con.createStatement();
String query="select sum(e),sum(c) from calculation";
ResultSet rs3=s.executeQuery(query);
if(rs3.next())
{
    b1=(rs3.getFloat(1))/(rs3.getFloat(2));
}
    
%>
<%
b0=(m2-(b1*m1));
%>
<br>
<mark>
Where M1=<%=m1%>,M2=<%=m2%><br><br><br>b1=<%=b1%><br><br><br>b0=<%=b0%>
<br><br>
The Regression Equation is, Y=<%=b0%>+<%=b1%>X
<br><br>
<table align="center" width="40%">
    <tr>
     <th>Weather Condition</th>
     <th>No of Accidents</th>
    </tr>
<%
Statement stmt=con.createStatement();
String qry4="select * from dataset2";
ResultSet rs4=stmt.executeQuery(qry4);
while(rs4.next())
{
    y=b0+(b1*rs4.getInt(2));    
%>
<tr><td align="center"><%=rs4.getInt(2)%></td><td align="center"><%=y%></td></tr>
<%
}
%>  
</table>
</mark>
</div>
    </body>
</html>