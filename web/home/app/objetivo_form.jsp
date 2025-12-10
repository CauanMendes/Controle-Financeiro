<%@page import="model.Usuario"%>
<%@page import="model.Objetivo"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Objetivo</title>
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
            width: 450px;
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
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #ffc107;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 20px;
        }

        input[type="submit"]:hover {
            background-color: #e0a800;
        }
    </style>
</head>

<body>
    <%@include file="/home/app/modulos.jsp" %>
    
<div class="form-container">
    
    <%
        Objetivo o = null;
        String action = request.getParameter("action");
        
        // Recupera a string da sessão - AGORA NO FORMATO: (ID, Nome, Email)
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
                o = new Objetivo();
                o.setId(id);
                o.load();
            } catch (Exception e) {
                e.printStackTrace();
                // Em caso de erro, trata como create
                action = "create";
                o = null;
            }
        }
    %>

    <h1>Formulário Objetivo</h1>

    <form action="<%= request.getContextPath() %>/home?action=<%= action %>&task=objetivo" method="post">

        <% if (action.equals("create")) { %>
            <input type="hidden" name="id" value="0">
        <% } else { %>
            <label for="id">ID:</label>
            <input type="text" name="id" value="<%= (o != null) ? o.getId() : "" %>" readonly>
        <% } %>

        <label for="descricao">Descrição:</label>
        <input type="text"
               name="descricao" id="descricao"
               value="<%= (o != null && o.getDescricao() != null) ? o.getDescricao() : "" %>"
               required>

        <label for="valor">Valor:</label>
        <input type="number"
               name="valor" id="valor"
               step="0.01"
               min="0"
               value="<%= (o != null) ? o.getValor() : "" %>"
               required>

        <label for="dataObjetivo">Data do Objetivo:</label>
        <input type="date"
               name="dataObjetivo" id="dataObjetivo"
               value="<%= (o != null && o.getDataObjetivo() != null) ? o.getDataObjetivo() : "" %>"
               required>

        <!-- Campo HIDDEN para o usuarioId -->
        <input type="hidden"
               name="usuarioId" id="usuarioId"
               value="<%= usuarioId %>">
        

        <input type="submit" value="Salvar">
    </form>
</div>
</body>
</html>