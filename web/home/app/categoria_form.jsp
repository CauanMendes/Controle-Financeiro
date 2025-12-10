<%@page import="model.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Categoria</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .form-container {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 400px;
        }

        h1 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            margin-top: 10px;
        }

        input[type="text"],
        select {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #dc3545;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #c82333;
        }
        
        .user-info {
            background-color: #e9f7ef;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
            border-left: 4px solid #28a745;
        }
    </style>
</head>

<body>
    <%@include file="/home/app/modulos.jsp" %>
<div class="form-container">

    <%
        Categoria c = null;
        String action = request.getParameter("action");
        
        // Recupera dados do usuário da sessão - FORMATO: (ID, Nome, Email)
        String usuarioSessao = (String) session.getAttribute("usuario");
        int usuarioId = 0;
        String usuarioNome = "";
        String usuarioEmail = "";
        
        if (usuarioSessao != null && usuarioSessao.startsWith("(")) {
            try {
                // Remove os parênteses: "(ID, Nome, Email)" → "ID, Nome, Email"
                String dados = usuarioSessao.substring(1, usuarioSessao.length() - 1);
                String[] partes = dados.split(",");
                
                if (partes.length >= 3) {
                    // ID (primeira parte)
                    usuarioId = Integer.parseInt(partes[0].trim());
                    
                    // Nome (segunda parte)
                    usuarioNome = partes[1].trim();
                    
                    // Email (terceira parte)
                    usuarioEmail = partes[2].trim();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (action == null) {
            action = "create";
        } else if (action.equals("update")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                c = new Categoria();
                c.setId(id);
                c.load();
            } catch (Exception e) {
                e.printStackTrace();
                // Em caso de erro, trata como create
                action = "create";
                c = null;
            }
        }
    %>

    <h1>Formulário Categoria</h1>
    


    <form action="<%= request.getContextPath() %>/home?action=<%= action %>&task=categoria" method="post">
        
        <% if (action.equals("create")) { %>
            <input type="hidden" name="id" value="0">
        <% } else { %>
            <label for="id">ID:</label>
            <input type="text" name="id" value="<%= (c != null) ? c.getId() : "" %>" readonly>
        <% } %>
        
        <!-- Campo HIDDEN para o usuarioId -->
        <input type="hidden"
               name="usuarioId" id="usuarioId"
               value="<%= usuarioId %>">

        <label for="nome">Nome:</label>
        <input type="text"
               name="nome" id="nome"
               value="<%= (c != null && c.getNome() != null) ? c.getNome() : "" %>"
               required>

        <label for="tipo">Tipo:</label>
        <select name="tipo" id="tipo" required>
            <option value="">Selecione o tipo</option>
            <!-- CORREÇÃO: Os valores DEVEM ser "receita" e "despesa" (sem o 's') -->
            <option value="receitas" <%= (c != null && "receitas".equals(c.getTipo())) ? "selected" : "" %>>Receitas</option>
            <option value="despesas" <%= (c != null && "despesas".equals(c.getTipo())) ? "selected" : "" %>>Despesas</option>
        </select>

        <input type="submit" value="Salvar">
    </form>
</div>
</body>
</html>