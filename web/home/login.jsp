<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>

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
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="text"],
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
            padding: 10px;
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

        .link {
            display: block;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <!-- Mensagem de erro -->
    <%
        String msg = (String) request.getAttribute("msg");
        if (msg != null) {
    %>
        <script>alert("<%= msg %>");</script>
    <%
        }
    %>

    <!-- Redireciona se já estiver logado -->
    <%
        HttpSession sessao = request.getSession(false);

        if (sessao != null &&
            sessao.getAttribute("usuario") != null) {

            response.sendRedirect(request.getContextPath() + "/home/app/menu.jsp");
            return;
        }
    %>

    <%
        String emailCookie = "";

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("email")) {
                    emailCookie = c.getValue();
                }
            }
        }
    %>

    <div class="form-container">
        <h1>Login</h1>

        <form action="<%= request.getContextPath() %>/home?task=login" method="post">

            <label for="email">Email:</label>
            <input type="text" name="email" id="email"
                   value="<%= emailCookie %>" required>

            <label for="senha">Senha:</label>
            <input type="password" name="senha" id="senha" required>

            <a class="link" href="<%= request.getContextPath() %>/home/usuario_form.jsp">
                Cadastrar-se
            </a>

            <input type="submit" value="Login">
        </form>
    </div>

</body>
</html>