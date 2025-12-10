<%@page import="model.Movimentacao"%>
<%@page import="model.Categoria"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Movimentação</title>
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
        input[type="date"],
        select {
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
            background-color: #28a745;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 20px;
        }

        input[type="submit"]:hover {
            background-color: #218838;
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
        Movimentacao m = null;
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
                m = new Movimentacao();
                m.setId(id);
                m.load();
            } catch (Exception e) {
                e.printStackTrace();
                // Em caso de erro, trata como create
                action = "create";
                m = null;
            }
        }
        
        // Carregar categorias para o select
        ArrayList<Categoria> categorias = new ArrayList<>();
        try {
            Categoria cat = new Categoria();
            categorias = cat.loadAll();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>

    <h1>Formulário Movimentação</h1>
   

    <form action="<%= request.getContextPath() %>/home?action=<%= action %>&task=movimentacao" method="post">

         <% if (action.equals("create")) { %>
            <input type="hidden" name="id" value="0">
        <% } else { %>
            <label for="id">ID:</label>
            <input type="text" name="id" value="<%= (m != null) ? m.getId() : "" %>" readonly>
        <% } %>
        
        <label for="descricao">Descrição:</label>
        <input type="text"
               name="descricao" id="descricao"
               value="<%= (m != null && m.getDescricao() != null) ? m.getDescricao() : "" %>"
               required>

        <label for="valor">Valor:</label>
        <input type="number"
               name="valor" id="valor"
               step="0.01"
               min="0"
               value="<%= (m != null) ? m.getValor() : "" %>"
               required>

        <label for="dataMovimentacao">Data:</label>
        <input type="date"
               name="dataMovimentacao" id="dataMovimentacao"
               value="<%= (m != null && m.getDataMovimentacao() != null) ? m.getDataMovimentacao() : "" %>"
               required>

        <!-- Campo HIDDEN para o usuarioId -->
        <input type="hidden"
               name="usuarioId" id="usuarioId"
               value="<%= usuarioId %>">

        <label for="categoriaId">Categoria:</label>
        <select name="categoriaId" id="categoriaId" required>
            <option value="">Selecione uma categoria</option>
            <%
                for (Categoria cat : categorias) {
                    String selected = "";
                    if (m != null && m.getCategoriaId() == cat.getId()) {
                        selected = "selected";
                    }
            %>
            <option value="<%= cat.getId() %>" <%= selected %>>
                <%= cat.getNome() %> (<%= cat.getTipo() %>)
            </option>
            <%
                }
            %>
        </select>

        <input type="submit" value="Salvar">
    </form>
</div>
</body>
</html>