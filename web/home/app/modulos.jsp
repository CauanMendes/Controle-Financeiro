
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String usuarioLogado = (String) session.getAttribute("usuario");
    
    if(usuarioLogado == null){
        response.sendRedirect(request.getContextPath() + "home/login.jsp");
    } 
    

    
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu</title>
    <style>
        /* Estilizando o menu */
        menu {
            list-style-type: none;
            padding: 0;
            margin: 0;
            background-color: #333;
            text-align: center;
        }

        menu li {
            display: inline-block;
        }

        menu li a {
            display: block;
            padding: 10px 20px;
            color: white;
            text-decoration: none;
            font-size: 16px;
        }

        menu li a:hover {
            background-color: #575757;
        }
    </style>
</head>
<body>
    <menu>
        <li><a href="<%= request.getContextPath() %>/home/app/menu.jsp">Menu</a></li>

        <li><a href="<%= request.getContextPath() %>/home/app/usuario.jsp">Usuario</a></li>
        <li><a href="<%= request.getContextPath() %>/home/app/movimentacao.jsp">Movimentação</a></li>
        <li><a href="<%= request.getContextPath() %>/home/app/categoria.jsp">Categoria</a></li>
        <li><a href="<%= request.getContextPath() %>/home/app/objetivo.jsp">Objetivo</a></li>

        <li><a href="<%= request.getContextPath() %>/home?task=logout">Logout<%= session.getAttribute("usuario")%></a></li>

    </menu>
</body>
</html>
