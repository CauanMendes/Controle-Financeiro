<%@page import="model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Usuário</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
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
        }

        input[type="text"],
        input[type="number"],
        input[type="password"] {
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
            background-color: #007BFF;
            color: white;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>

<body>
<div class="form-container">

    <%
        Usuario u = null;
        String action = request.getParameter("action");

        if (action == null) {
            action = "create";
        } else if (action.equals("update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            u = new Usuario();
            u.setId(id);
            u.load();
        }
    %>

    <h1>Formulário Usuário</h1>

    <form action="<%= request.getContextPath() %>/home?action=<%= action %>&task=usuario" method="post">

        <label for="id">ID:</label>
        <input type="text"
               name="id" id="id"
               pattern="\d+" title="Apenas números"
               value="<%= (u != null) ? u.getId() : "" %>"
               <%= (u != null) ? "readonly" : "" %>
               required>

        <label for="nome">Nome:</label>
        <input type="text"
               name="nome" id="nome"
               value="<%= (u != null && u.getNome() != null) ? u.getNome() : "" %>"
               required>

        <label for="email">Email:</label>
        <input type="text"
               name="email" id="email"
               value="<%= (u != null && u.getEmail() != null) ? u.getEmail() : "" %>"
               required>

        <label for="senha">Senha:</label>
        <input type="password"
               name="senha" id="senha"
               value="<%= (u != null && u.getSenha() != null) ? u.getSenha() : "" %>"
               required>

        <input type="submit" value="Salvar">
    </form>
</div>
</body>
</html>
