<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%
  int id=Integer.parseInt(request.getParameter("codigo"));
%>
<h2>Introduzca los datos a editar <%=id%>:</h2>
<form method="get" action="editarPartido.jsp">
  fecha <input type="text" name="fecha"/></br>
  equipo1 <input type="text" name="equipo1"/></br>
  puntos equipo 1 <input type="text" name="puntos_equipo1"/></br>
  equipo2 <input type="text" name="equipo2"/></br>
  puntos equipo 2 <input type="text" name="puntos_equipo2"/></br>
  tipo_partido <input type="text" name="tipo_partido"/></br>
  <input type="hidden" name="codigo" value="<%=id%>"/>
  <input type="submit" value="Aceptar">
</form>
</body>
<%
  String error =(String) session.getAttribute("error");
  if(error!=null){
%>
<span style="color:red; background:yellow"><%= error %> </span>
<%
    session.removeAttribute("error");
  }
%>
</html>