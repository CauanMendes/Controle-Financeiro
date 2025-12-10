<%@page import="model.Usuario"%>
<%@page import="java.util.ArrayList"%>
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
        input[type="email"],
        input[type="number"],
        input[type="password"] {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
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
            font-size: 16px;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            border: 1px solid #f5c6cb;
            display: none;
            font-size: 14px;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 10px 15px;
            border-radius: 5px;
            margin-bottom: 15px;
            border: 1px solid #c3e6cb;
            display: none;
            font-size: 14px;
        }
        
        .error-input {
            border-color: #dc3545 !important;
            background-color: #fff8f8;
        }
        
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #007BFF;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .required::after {
            content: " *";
            color: #dc3545;
        }
        
        .info-note {
            background-color: #e7f3ff;
            color: #004085;
            padding: 8px 12px;
            border-radius: 5px;
            margin-bottom: 15px;
            border-left: 4px solid #007BFF;
            font-size: 13px;
        }
    </style>
    <script>
        // Captura parâmetros da URL
        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        }
        
        // Validação do formulário
        function validateForm() {
            var isValid = true;
            var errorMessage = "";
            
            // Resetar estilos de erro
            document.getElementById('id').classList.remove('error-input');
            document.getElementById('nome').classList.remove('error-input');
            document.getElementById('email').classList.remove('error-input');
            document.getElementById('senha').classList.remove('error-input');
            
            // Validação do ID (agora obrigatório sempre)
            var id = document.getElementById('id').value.trim();
            if (id === '') {
                document.getElementById('id').classList.add('error-input');
                errorMessage += "ID é obrigatório.<br>";
                isValid = false;
            } else if (!/^\d+$/.test(id)) {
                document.getElementById('id').classList.add('error-input');
                errorMessage += "ID deve conter apenas números.<br>";
                isValid = false;
            }
            
            // Validação do nome
            var nome = document.getElementById('nome').value.trim();
            if (nome === '') {
                document.getElementById('nome').classList.add('error-input');
                errorMessage += "Nome é obrigatório.<br>";
                isValid = false;
            }
            
            // Validação do email
            var email = document.getElementById('email').value.trim();
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (email === '') {
                document.getElementById('email').classList.add('error-input');
                errorMessage += "Email é obrigatório.<br>";
                isValid = false;
            } else if (!emailRegex.test(email)) {
                document.getElementById('email').classList.add('error-input');
                errorMessage += "Email inválido. Use o formato exemplo@dominio.com<br>";
                isValid = false;
            }
            
            // Validação da senha
            var senha = document.getElementById('senha').value;
            if (senha === '') {
                document.getElementById('senha').classList.add('error-input');
                errorMessage += "Senha é obrigatória.<br>";
                isValid = false;
            }
            
            // Mostrar mensagens de erro
            if (!isValid) {
                document.getElementById('errorMessage').innerHTML = errorMessage;
                document.getElementById('errorMessage').style.display = 'block';
                document.getElementById('successMessage').style.display = 'none';
            }
            
            return isValid;
        }
        
        // Ao carregar a página
        window.onload = function() {
            // Verificar se há mensagens de erro/sucesso na URL
            var messageParam = getUrlParameter('message');
            var errorParam = getUrlParameter('error');
            var successParam = getUrlParameter('success');
            
            if (messageParam) {
                document.getElementById('errorMessage').innerText = messageParam;
                document.getElementById('errorMessage').style.display = 'block';
            } else if (errorParam) {
                document.getElementById('errorMessage').innerText = errorParam;
                document.getElementById('errorMessage').style.display = 'block';
                
                if (errorParam.includes('ID') || errorParam.includes('id')) {
                    document.getElementById('id').classList.add('error-input');
                }
                if (errorParam.includes('Email') || errorParam.includes('email')) {
                    document.getElementById('email').classList.add('error-input');
                }
            } else if (successParam) {
                document.getElementById('successMessage').innerText = successParam;
                document.getElementById('successMessage').style.display = 'block';
            }
            
            // Focar no campo ID se estiver vazio
            if (document.getElementById('id').value === '') {
                document.getElementById('id').focus();
            } else if (document.getElementById('nome').value === '') {
                document.getElementById('nome').focus();
            } else {
                document.getElementById('id').focus();
            }
        };
    </script>
</head>

<body>
<div class="form-container">

    <%
        Usuario u = null;
        String action = request.getParameter("action");
        String errorMessage = null;
        String successMessage = null;
        
        String messageParam = request.getParameter("message");
        String errorParam = request.getParameter("error");
        String successParam = request.getParameter("success");
        
        if (messageParam != null) {
            errorMessage = messageParam;
        } else if (errorParam != null) {
            errorMessage = errorParam;
        } else if (successParam != null) {
            successMessage = successParam;
        }
        
        if (action == null) {
            action = "create";
        } else if (action.equals("update")) {
            try {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    errorMessage = "ID é obrigatório para atualização";
                } else {
                    int id = Integer.parseInt(idParam);
                    u = new Usuario();
                    u.setId(id);
                    boolean loaded = u.load();
                    
                    if (!loaded) {
                        errorMessage = "Usuário não encontrado com ID: " + id;
                        u = null;
                    }
                }
            } catch (NumberFormatException e) {
                errorMessage = "ID inválido. Deve ser um número.";
            } catch (Exception e) {
                errorMessage = "Erro ao carregar usuário: " + e.getMessage();
            }
        }
    %>

    <h1><%= action.equals("update") ? "Editar Usuário" : "Novo Usuário" %></h1>
    
    <% if (action.equals("create")) { %>
    <div class="info-note">
        <strong>Importante:</strong> O ID é obrigatório pois o banco não tem auto-incremento.
        Escolha um número único que ainda não exista no sistema.
    </div>
    <% } %>
    
    <% if (errorMessage != null) { %>
    <div class="error-message" id="errorMessage" style="display: block;">
        <%= errorMessage %>
    </div>
    <% } else if (successMessage != null) { %>
    <div class="success-message" id="successMessage" style="display: block;">
        <%= successMessage %>
    </div>
    <% } else { %>
    <div class="error-message" id="errorMessage"></div>
    <div class="success-message" id="successMessage"></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/home?action=<%= action %>&task=usuario" 
          method="post" 
          onsubmit="return validateForm()">

        <label for="id" class="required">ID:</label>
        <input type="text"
               name="id" id="id"
               pattern="\d+" title="Apenas números"
               value="<%= (u != null) ? u.getId() : "" %>"
               <%= (action.equals("update")) ? "readonly" : "" %>
               required
               placeholder="Digite um número único"
               oninput="this.classList.remove('error-input')">

        <label for="nome" class="required">Nome:</label>
        <input type="text"
               name="nome" id="nome"
               value="<%= (u != null && u.getNome() != null) ? u.getNome() : "" %>"
               required
               maxlength="100"
               placeholder="Digite o nome completo"
               oninput="this.classList.remove('error-input')">

        <label for="email" class="required">Email:</label>
        <input type="email"
               name="email" id="email"
               value="<%= (u != null && u.getEmail() != null) ? u.getEmail() : "" %>"
               required
               maxlength="100"
               placeholder="exemplo@email.com"
               oninput="this.classList.remove('error-input')">

        <label for="senha" class="required">Senha:</label>
        <input type="password"
               name="senha" id="senha"
               value="<%= (u != null && u.getSenha() != null) ? u.getSenha() : "" %>"
               required
               minlength="6"
               placeholder="Mínimo 6 caracteres"
               oninput="this.classList.remove('error-input')">

        <input type="submit" value="<%= action.equals("update") ? "Atualizar" : "Salvar" %>">
    </form>
    
    <a href="<%= request.getContextPath() %>/home/login.jsp" class="back-link">
        ← Voltar para Login
    </a>
</div>
</body>
</html>