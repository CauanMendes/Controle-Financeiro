<%@page import="model.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuário</title>
        <style>
     body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            flex-direction: column;
            align-items: center; /* centraliza conteúdo horizontalmente */
            padding: 20px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            border-collapse: collapse;
            width: 80%;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-bottom: 20px; /* espaço abaixo da tabela */
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px 15px;
            text-align: center;
        }

        th {
            background-color: #007BFF;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        a {
            color: #007BFF;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .add-link {
            font-weight: bold;
            text-align: center;
            margin-top: 10px;
        }
    </style>
    </head>
    <body>
        
        <%@include file="/home/app/modulos.jsp" %>
        
        <% ArrayList<Usuario> dados = new Usuario().getAllTableEntities(); %>
        
        <h1>Lista de Usuários</h1>
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Email</th>
                <th></th>
                <th></th>
            </tr>
            
            <%
                for(Usuario info : dados) {
            %>
            <tr>
                <td><%= info.getId() %></td>
                <td><%= info.getNome() %></td>
                <td><%= info.getEmail() %></td>
                
                <td>
                    <a href="<%= request.getContextPath() %>/home/usuario_form.jsp?action=update&id=<%= info.getId() %>">
                        Alterar
                    </a>
                </td>
                <td>
                    <a href="<%= request.getContextPath() %>/home?action=delete&id=<%= info.getId() %>&task=usuario"
                       onclick="return confirm('Deseja realmente excluir o Usuário <%= info.getId() %> (<%= info.getNome() %>) ?')">
                        Excluir
                    </a>
                </td>
            </tr>
            <%
                }
            %>
        </table><br>
    </body>
</html>
