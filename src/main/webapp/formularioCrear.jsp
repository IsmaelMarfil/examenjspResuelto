<%--
  Created by IntelliJ IDEA.
  User: Usuario
  Date: 20/12/2023
  Time: 12:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<form method="get" action="grabarPartido.jsp">
    id<input type="text" name="id"><br>
    fecha<input type="text" name="fecha"><br>
    equipo1<input type="text" name="equipo1"><br>
    puntos_equipo1<input type="text" name="puntos_equipo1"><br>
    equipo2<input type="text" name="equipo2"><br>
    puntos_equipo2<input type="text" name="puntos_equipo2"><br>
    tipo_partido<input type="text" name="tipo_partido"><br>
    <input type="submit" value="Aceptar"><br>
</form>
<body>
    <%
        String error =(String) session.getAttribute("error");
           if(error!=null){
    %>
    <span style="color:red">error</span>
    <%
        session.removeAttribute("error");
        }
    %>
</body>
</html>
