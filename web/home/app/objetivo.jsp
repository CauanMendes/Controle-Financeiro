<%@page import="model.Objetivo"%>
<%@page import="model.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Objetivos</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f2f2f2;
                display: flex;
                justify-content: center;
                flex-direction: column;
                align-items: center;
                padding: 20px;
            }

            h1 {
                text-align: center;
                margin-bottom: 20px;
                color: #333;
            }

            table {
                border-collapse: collapse;
                width: 90%;
                background-color: #fff;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            th, td {
                border: 1px solid #ccc;
                padding: 10px 15px;
                text-align: center;
            }

            th {
                background-color: #ffc107;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .valor {
                color: #17a2b8;
                font-weight: bold;
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
                display: inline-block;
                background-color: #ffc107;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                margin-bottom: 20px;
            }

            .add-link:hover {
                background-color: #e0a800;
                text-decoration: none;
            }
            
            .user-info {
                background-color: #e9f7ef;
                padding: 10px 15px;
                border-radius: 5px;
                margin-bottom: 15px;
                text-align: center;
                border-left: 4px solid #28a745;
            }
            
            .empty-message {
                text-align: center;
                padding: 30px;
                background-color: #f8f9fa;
                border-radius: 5px;
                color: #6c757d;
                font-size: 16px;
            }
        </style>
    </head>
    <body>
        
        <%@include file="/home/app/modulos.jsp" %>
        
        <% 
            // Recupera o usuário da sessão
            String usuarioSessao = (String) session.getAttribute("usuario");
            int usuarioId = 0;
            String usuarioNome = "";
            ArrayList<Objetivo> dados = new ArrayList<>();
            NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance();
            
            if (usuarioSessao != null && usuarioSessao.contains(",")) {
                try {
                    // Extrai nome e email da string "(Nome, email)"
                    String[] partes = usuarioSessao.split(",");
                    if (partes.length >= 2) {
                        usuarioNome = partes[0].trim().replace("(", "");
                        String usuarioEmail = partes[1].trim().replace(")", "");
                        
                        // Carrega o usuário para pegar o ID
                        Usuario usuario = new Usuario();
                        usuario.setEmail(usuarioEmail);
                        if (usuario.loadByEmail()) {
                            usuarioId = usuario.getId();
                            
                            // Carrega apenas os objetivos deste usuário
                            if (usuarioId > 0) {
                                Objetivo obj = new Objetivo();
                                dados = obj.loadByUsuarioId(usuarioId);
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div style='color: red; padding: 10px;'>Erro: " + e.getMessage() + "</div>");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/home/login.jsp");
                return;
            }
        %>
        
        <h1>Meus Objetivos</h1>
       
        
        <a href="<%= request.getContextPath() %>/home/app/objetivo_form.jsp?action=create" class="add-link">
            + Novo Objetivo
        </a>
        
        <% if (dados.isEmpty()) { %>
            <div class="empty-message">
                Você ainda não possui objetivos cadastrados.<br>
                Clique em "+ Novo Objetivo" para começar.
            </div>
        <% } else { %>
        
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Descrição</th>
                <th>Valor</th>
                <th>Data do Objetivo</th>
                <th>Ações</th>
            </tr>
            
            <%
                for(Objetivo info : dados) {
            %>
            <tr>
                <td><%= info.getId() %></td>
                <td><%= info.getDescricao() %></td>
                <td class="valor">
                    <%= formatoMoeda.format(info.getValor()) %>
                </td>
                <td><%= info.getDataObjetivo() %></td>
                
                <td>
                    <a href="<%= request.getContextPath() %>/home/app/objetivo_form.jsp?action=update&id=<%= info.getId() %>"
                       style="margin-right: 10px;">
                        ✏️ Alterar
                    </a>
                    <a href="<%= request.getContextPath() %>/home?action=delete&id=<%= info.getId() %>&task=objetivo"
                       onclick="return confirm('Deseja realmente excluir o Objetivo "<%= info.getDescricao() %>" ?')"
                       style="color: #dc3545;">
                        🗑️ Excluir
                    </a>
                </td>
            </tr>
            <%
                }
            %>
        </table>
        <% } %>
        
    </body>
</html>