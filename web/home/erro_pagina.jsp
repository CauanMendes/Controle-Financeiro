<!DOCTYPE html>
<html>
    <head>
        <title>Página de Erro</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }
            
            body {
                background-color: #f8f9fa;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }
            
            .error-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                padding: 40px;
                text-align: center;
                max-width: 600px;
                width: 100%;
            }
            
            .error-icon {
                font-size: 80px;
                color: #dc3545;
                margin-bottom: 20px;
            }
            
            h1 {
                color: #dc3545;
                margin-bottom: 15px;
                font-size: 28px;
            }
            
            .error-message {
                color: #666;
                font-size: 16px;
                line-height: 1.6;
                margin-bottom: 25px;
            }
            
            .error-code {
                background: #f8d7da;
                color: #721c24;
                padding: 8px 15px;
                border-radius: 5px;
                display: inline-block;
                margin-bottom: 20px;
                font-weight: bold;
                border-left: 4px solid #dc3545;
            }
            
            .btn-menu {
                display: inline-block;
                background: #007bff;
                color: white;
                text-decoration: none;
                padding: 12px 25px;
                border-radius: 5px;
                font-weight: bold;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                font-size: 16px;
                margin-top: 10px;
            }
            
            .btn-menu:hover {
                background: #0056b3;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }
            
            .btn-back {
                display: inline-block;
                background: #6c757d;
                color: white;
                text-decoration: none;
                padding: 10px 20px;
                border-radius: 5px;
                margin-right: 10px;
                transition: all 0.3s ease;
            }
            
            .btn-back:hover {
                background: #545b62;
            }
            
            .error-details {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-top: 20px;
                border-left: 3px solid #ffc107;
                text-align: left;
                display: none;
            }
            
            .toggle-details {
                color: #6c757d;
                text-decoration: none;
                font-size: 14px;
                cursor: pointer;
                display: block;
                margin-top: 15px;
            }
            
            .toggle-details:hover {
                color: #007bff;
            }
            
            @media (max-width: 768px) {
                .error-container {
                    padding: 25px;
                }
                
                h1 {
                    font-size: 24px;
                }
                
                .error-icon {
                    font-size: 60px;
                }
                
                .btn-menu, .btn-back {
                    display: block;
                    width: 100%;
                    margin-bottom: 10px;
                }
                
                .btn-back {
                    margin-right: 0;
                }
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-icon">??</div>
            
            <h1>Ocorreu um Erro</h1>
            
            <div class="error-code" id="errorCode">
                Erro no Sistema
            </div>
            
            <% 
                // Captura a mensagem de erro do parâmetro
                String mensagem = request.getParameter("message");
                
                if (mensagem != null && !mensagem.isEmpty()) {
                    // Decodifica a mensagem (foi codificada no URL)
                    mensagem = java.net.URLDecoder.decode(mensagem, "UTF-8");
            %>
                <div class="error-message" style="background-color: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;">
                    <strong>Detalhes do erro:</strong><br>
                    <%= mensagem %>
                </div>
            <% } else { %>
                <div class="error-message">
                    Ocorreu um erro inesperado no sistema.
                </div>
            <% } %>
            
            <div style="margin-top: 30px;">
                <a href="javascript:history.back()" class="btn-back">? Voltar</a>
                <a href="/controlefinanceiro/home/app/menu.jsp" class="btn-menu">Ir para o Menu</a>
            </div>
        </div>
    </body>
</html>