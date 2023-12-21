<%@page import="java.sql.*" %>
<%@page import="java.util.Objects" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<%

    List<String> errores = (List<String>) session.getAttribute("erroresValidacion");
    session.removeAttribute("erroresValidacion"); // Limpiar la sesión después de usar los errores

    if (errores != null && !errores.isEmpty()) {
        for (String error : errores) {
%>
<div class="error-message"><%= error %></div>
<%
        }
    }

    //CÓDIGO DE VALIDACIÓN
    boolean valida = true;
    int numero = -1;
    java.sql.Date fecha=null;
    String equipo1 = null;
    String equipo2 = null;
    int puntos_equipo1 = -1;
    int puntos_equipo2 = -1;
    String tipo_partido = null;
    boolean flagValidaNumero = false;
    boolean flagValidaFecha = false;
    boolean flagValidaEquipo1 = false;
    boolean flagValidaEquipo2 = false;
    boolean flagValidapuntos_Equipo1 = false;
    boolean flagValidapuntos_Equipo2 = false;
    boolean flagValidatipoPartido = false;
    SimpleDateFormat format =new SimpleDateFormat("YYYY-MM-DD");
    try {


        //UTILIZO LOS CONTRACTS DE LA CLASE Objects PARA LA VALIDACIÓN
        //             v---- LANZA NullPointerException SI EL PARÁMETRO ES NULL
        Objects.requireNonNull(request.getParameter("fecha"));
        flagValidaFecha = true;

        //CONTRACT nonBlank..
        //UTILIZO isBlank SOBRE EL PARÁMETRO DE TIPO String PARA CHEQUEAR QUE NO ES UN PARÁMETRO VACÍO "" NI CADENA TODO BLANCOS "    "
        //          |                                EN EL CASO DE QUE SEA BLANCO LO RECIBIDO, LANZO UNA EXCEPCIÓN PARA INVALIDAR EL PROCESO DE VALIDACIÓN
        //          -------------------------v                      v---------------------------------------|
        if (request.getParameter("fecha").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaFecha = true;
        fecha= java.sql.Date.valueOf(request.getParameter("fecha"));
        if (request.getParameter("equipo1").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaEquipo1 = true;
        equipo1 = request.getParameter("equipo1");
        if (request.getParameter("equipo2").isBlank()) throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidaEquipo2 = true;
        equipo2 = request.getParameter("equipo2");
        if(Integer.parseInt(request.getParameter("puntos_equipo1"))<0)throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidapuntos_Equipo1=true;
        puntos_equipo1=Integer.parseInt(request.getParameter("puntos_equipo1"));
        if(Integer.parseInt(request.getParameter("puntos_equipo2"))<0)throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidapuntos_Equipo2=true;
        puntos_equipo2=Integer.parseInt(request.getParameter("puntos_equipo2"));
        if(request.getParameter("tipo_partido").isBlank())throw new RuntimeException("Parámetro vacío o todo espacios blancos.");
        flagValidatipoPartido=true;
        tipo_partido=request.getParameter("tipo_partido");




    } catch (Exception ex) {
        ex.printStackTrace();

        if (!flagValidaNumero) {
            session.setAttribute("error", "Error en número.");
        } else if (!flagValidaEquipo1) {
            session.setAttribute("error", "Error en nombre.");
        } else if (!flagValidaFecha) {
            session.setAttribute("error", "Error en edad.");
        } else if (!flagValidaEquipo2) {
            session.setAttribute("error", "Error en estatura.");
        } else if (!flagValidatipoPartido) {
            session.setAttribute("error", "Error en localidad.");
        }else if(!flagValidapuntos_Equipo1){
            session.setAttribute("error", "Error en localidad.");
        }else if(!flagValidapuntos_Equipo2){
            session.setAttribute("error", "Error en localidad.");
        }



        valida = false;
    }
    //FIN CÓDIGO DE VALIDACIÓN

    if (valida) {

        Connection conn = null;
        PreparedStatement ps = null;
// 	ResultSet rs = null;

        try {

            //CARGA DEL DRIVER Y PREPARACIÓN DE LA CONEXIÓN CON LA BBDD
            //						v---------UTILIZAMOS LA VERSIÓN MODERNA DE LLAMADA AL DRIVER, no deprecado
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/juego", "user", "user");


//>>>>>>NO UTILIZAR STATEMENT EN QUERIES PARAMETRIZADAS
//       Statement s = conexion.createStatement();
//       String insercion = "INSERT INTO socio VALUES (" + Integer.valueOf(request.getParameter("numero"))
//                          + ", '" + request.getParameter("nombre")
//                          + "', " + Integer.valueOf(request.getParameter("estatura"))
//                          + ", " + Integer.valueOf(request.getParameter("edad"))
//                          + ", '" + request.getParameter("localidad") + "')";
//       s.execute(insercion);
//<<<<<<



            ps = conn.prepareStatement("INSERT INTO partido (fecha, equipo1,puntos_equipo1,equipo2,puntos_equipo2,tipo_partido ) VALUES (?, ?, ?, ?, ?, ?) ",Statement.RETURN_GENERATED_KEYS);
            int idx = 1;
            ps.setDate(idx++, new java.sql.Date(fecha.getTime()));
            ps.setString(idx++, equipo1);
            ps.setInt(idx++, puntos_equipo1);
            ps.setString(idx++, equipo2);
            ps.setInt(idx++, puntos_equipo2);
            ps.setString(idx++,tipo_partido);

            int filasAfectadas = ps.executeUpdate();
            System.out.println("SOCIOS GRABADOS:  " + filasAfectadas);


        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            //BLOQUE FINALLY PARA CERRAR LA CONEXIÓN CON PROTECCIÓN DE try-catch
            //SIEMPRE HAY QUE CERRAR LOS ELEMENTOS DE LA  CONEXIÓN DESPUÉS DE UTILIZARLOS
            //try { rs.close(); } catch (Exception e) { /* Ignored */ }
            try {
                ps.close();
            } catch (Exception e) { /* Ignored */ }
            try {
                conn.close();
            } catch (Exception e) { /* Ignored */ }
        }

            response.sendRedirect("listadoPartido.jsp");

    } else {

        // Almacenar errores en la sesión
        session.setAttribute("erroresValidacion", errores);

        // Realizar forwarding a la página anterior (formularioSocio.jsp)
        RequestDispatcher dispatcher = request.getRequestDispatcher("formularioCrear.jsp");
        dispatcher.forward(request, response);

    }
%>

</body>
</html>