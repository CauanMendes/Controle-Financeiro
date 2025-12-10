<%@page import="model.Usuario"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Usuários</title>
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
                width: 80%;
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
                display: inline-block;
                background-color: #007BFF;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                margin-bottom: 20px;
            }

            .add-link:hover {
                background-color: #0056b3;
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
            
            .acao-alterar {
                color: #007BFF;
                text-decoration: none;
                margin-right: 10px;
            }

            .acao-excluir {
                color: #dc3545;
                text-decoration: none;
            }

            .acao-alterar:hover, .acao-excluir:hover {
                text-decoration: underline;
            }
            
            .warning-message {
                background-color: #fff3cd;
                border: 1px solid #ffc107;
                color: #856404;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        
        <%@include file="/home/app/modulos.jsp" %>
        
        <% 
            // Obtém a string do usuário da sessão
            String usuarioSessaoStr = (String) session.getAttribute("usuario");
            
            // Verifica se há usuário logado
            if (usuarioSessaoStr == null || usuarioSessaoStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home/login.jsp");
                return;
            }
            
            // Extrai informações do usuário da string salva na sessão
            // Formato: "(id, nome, email)"
            String usuarioStr = usuarioSessaoStr.replace("(", "").replace(")", "");
            String[] partes = usuarioStr.split(",");
            
            if (partes.length < 3) {
                response.sendRedirect(request.getContextPath() + "/home/login.jsp");
                return;
            }
            
            String idStr = partes[0].trim();
            String nomeUsuario = partes[1].trim();
            String emailUsuario = partes[2].trim();
            
            // Busca o usuário completo do banco de dados pelo ID
            int idUsuario = Integer.parseInt(idStr);
            Usuario usuarioLog = new Usuario();
            usuarioLog.setId(idUsuario);
            boolean encontrado = usuarioLog.loadById();
            
            if (!encontrado) {
                response.sendRedirect(request.getContextPath() + "/home/login.jsp");
                return;
            }
        %>
        
        <h1>Meus Dados</h1>
        
        <div class="warning-message">
            <strong>Atenção:</strong> Você está visualizando apenas seus próprios dados.
            Se excluir sua conta, será desconectado do sistema.
        </div>
        
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Email</th>
                <th>Ações</th>
            </tr>
            
            <tr>
                <td><%= usuarioLog.getId() %></td>
                <td><%= usuarioLog.getNome() %></td>
                <td><%= usuarioLog.getEmail() %></td>
                
                <td>
                    <a href="<%= request.getContextPath() %>/home/usuario_form.jsp?action=update&id=<%= usuarioLog.getId() %>"
                       style="margin-right: 10px;">
                        ✏️ Alterar
                    </a>
                    <a href="<%= request.getContextPath() %>/home?action=delete&id=<%= usuarioLog.getId() %>&task=usuario"
                       onclick="return confirm('ATENÇÃO! Deseja realmente excluir SUA PRÓPRIA CONTA?\\n\\nVocê será desconectado do sistema.\\nNome: <%= usuarioLog.getNome() %>')"
                       style="color: #dc3545;">
                        🗑️ Excluir
                    </a>
                </td>
            </tr>
        </table>
        
        <div style="margin-top: 20px; text-align: center;">
            <a href="<%= request.getContextPath() %>/home" style="color: #007BFF;">← Voltar para a Home</a>
        </div>
        
    </body>
</html>