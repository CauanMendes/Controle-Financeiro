<%@page import="model.Categoria"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Minhas Categorias</title>
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
                width: 70%;
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
                background-color: #dc3545;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .tipo-receita {
                color: #28a745;
                font-weight: bold;
            }

            .tipo-despesa {
                color: #dc3545;
                font-weight: bold;
            }

            .tipo-investimento {
                color: #17a2b8;
                font-weight: bold;
            }

            .tipo-outro {
                color: #6c757d;
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
                background-color: #dc3545;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                margin-bottom: 20px;
            }

            .add-link:hover {
                background-color: #c82333;
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
            // Recupera dados do usuário da sessão
            String usuarioSessao = (String) session.getAttribute("usuario");
            int usuarioId = 0;
            String usuarioNome = "";
            String usuarioEmail = "";
            
            if (usuarioSessao != null && usuarioSessao.startsWith("(")) {
                try {
                    String dados = usuarioSessao.substring(1, usuarioSessao.length() - 1);
                    String[] partes = dados.split(",");
                    
                    if (partes.length >= 3) {
                        usuarioId = Integer.parseInt(partes[0].trim());
                        usuarioNome = partes[1].trim();
                        usuarioEmail = partes[2].trim();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            // Carrega apenas categorias deste usuário
            ArrayList<Categoria> dados = new ArrayList<>();
            if (usuarioId > 0) {
                try {
                    Categoria cat = new Categoria();
                    dados = cat.loadByUsuarioId(usuarioId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                // Se não tem usuário logado, redireciona
                response.sendRedirect(request.getContextPath() + "/home/login.jsp");
                return;
            }
        %>
        
        <h1>Minhas Categorias</h1>
        
        <a href="<%= request.getContextPath() %>/home/app/categoria_form.jsp?action=create" class="add-link">
            + Nova Categoria
        </a>
        
        <% if (dados.isEmpty()) { %>
            <div class="empty-message">
                Você ainda não possui categorias cadastradas.<br>
                Clique em "+ Nova Categoria" para começar.
            </div>
        <% } else { %>
        
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Tipo</th>
                <th>Ações</th>
            </tr>
            
            <%
                for(Categoria info : dados) {
                    String classeTipo = "tipo-outro";
                    if ("receita".equals(info.getTipo())) {
                        classeTipo = "tipo-receita";
                    } else if ("despesa".equals(info.getTipo())) {
                        classeTipo = "tipo-despesa";
                    } else if ("investimento".equals(info.getTipo())) {
                        classeTipo = "tipo-investimento";
                    }
            %>
            <tr>
                <td><%= info.getId() %></td>
                <td><%= info.getNome() %></td>
                <td class="<%= classeTipo %>">
                    <%= info.getTipo().toUpperCase() %>
                </td>
                
                <td>
                    <a href="<%= request.getContextPath() %>/home/app/categoria_form.jsp?action=update&id=<%= info.getId() %>"
                       style="margin-right: 10px;">
                        ✏️ Alterar
                    </a>
                    <a href="<%= request.getContextPath() %>/home?action=delete&id=<%= info.getId() %>&task=categoria"
                       onclick="return confirm('Deseja realmente excluir a Categoria \"<%= info.getNome() %>\" ?')"
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