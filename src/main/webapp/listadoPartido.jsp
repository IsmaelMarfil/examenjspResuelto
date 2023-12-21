<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: Usuario
  Date: 04/12/2023
  Time: 13:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
  //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
  //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
  Class.forName("com.mysql.cj.jdbc.Driver");
  Connection conexion = DriverManager.getConnection("jdbc:mysql://localhost:3306/juego","user", "user");

  //UTILIZAR STATEMENT SÓLO EN QUERIES NO PARAMETRIZADAS.
  Statement s = conexion.createStatement();
  ResultSet listado = s.executeQuery ("SELECT * FROM partido ");
%>
 <%
  Integer socioIDADestacar = (Integer)session.getAttribute("socioIDADestacar");
  String claseDestacar = "";
  while (listado.next()) {
  claseDestacar = (socioIDADestacar != null
  && socioIDADestacar==listado.getInt("socioID") ) ?
  "destacar" :  "";
%>


<tr>
  <td >
    <%=listado.getInt("id")%>
  </td>
  <td><%=listado.getString("fecha")%>
  </td>
  <td><%=listado.getString("puntos_equipo1")%>
  </td>
  <td><%=listado.getString("equipo2")%>
  </td>
  <td><%=listado.getInt("puntos_equipo2")%>
  </td>
  </td>
  <td><%=listado.getString("tipo_partido")%>
  </td>
  <td>
    <form method="get" action="borrarpartido.jsp">
      <input type="hidden" name="codigo" value="<%=listado.getString("id") %>"/>
      <input type="submit" value="borrar">
    </form>
  </td>
  <td>
    <form method="get" action="formularioCrear.jsp">
      <input type="submit" value="crear">
    </form>
  </td>
  <td>
    <form method="get" action="formularioEditar.jsp">
      <input type="hidden" name="codigo" value="<%=listado.getString("id") %>"/>
      <input type="submit" value="modificar">
    </form>
  </td>
</tr>
<%
  } // while

  listado.close();
  s.close();
  conexion.close();
%>
</body>
</html>
