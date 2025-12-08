<%@page import="model.Movimentacao"%>
<%@page import="model.Categoria"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.NumberFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Minhas Movimentações</title>
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
                background-color: #28a745;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .valor-receita {
                color: #28a745;
                font-weight: bold;
            }

            .valor-despesa {
                color: #dc3545;
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
                background-color: #28a745;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                margin-bottom: 20px;
            }

            .add-link:hover {
                background-color: #218838;
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
            
            if (usuarioSessao != null && usuarioSessao.startsWith("(")) {
                try {
                    String dados = usuarioSessao.substring(1, usuarioSessao.length() - 1);
                    String[] partes = dados.split(",");
                    
                    if (partes.length >= 3) {
                        usuarioId = Integer.parseInt(partes[0].trim());
                        usuarioNome = partes[1].trim();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            // Carrega apenas movimentações deste usuário
            ArrayList<Movimentacao> dados = new ArrayList<>();
            NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance();
            
            if (usuarioId > 0) {
                try {
                    Movimentacao mov = new Movimentacao();
                    dados = mov.loadByUsuarioId(usuarioId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                // Se não tem usuário logado, redireciona
                response.sendRedirect(request.getContextPath() + "/home/login.jsp");
                return;
            }
        %>
        
        <h1>Minhas Movimentações</h1> 
        
        <a href="<%= request.getContextPath() %>/home/app/movimentacao_form.jsp?action=create" class="add-link">
            + Nova Movimentação
        </a>
        
        <% if (dados.isEmpty()) { %>
            <div class="empty-message">
                Você ainda não possui movimentações cadastradas.<br>
                Clique em "+ Nova Movimentação" para começar.
            </div>
        <% } else { %>
        
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Descrição</th>
                <th>Valor</th>
                <th>Data</th>
                <th>Categoria</th>
                <th>Ações</th>
            </tr>
            
            <%
                for(Movimentacao info : dados) {
                    // Determinar se é receita ou despesa
                    String classeValor = "valor-despesa";
                    String nomeCategoria = "";
                    String tipoCategoria = "";
                    
                    try {
                        Categoria cat = new Categoria();
                        cat.setId(info.getCategoriaId());
                        if (cat.load()) {
                            nomeCategoria = cat.getNome();
                            tipoCategoria = cat.getTipo();
                            if ("receita".equals(tipoCategoria)) {
                                classeValor = "valor-receita";
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
            %>
            <tr>
                <td><%= info.getId() %></td>
                <td><%= info.getDescricao() %></td>
                <td class="<%= classeValor %>">
                    <%= formatoMoeda.format(info.getValor()) %>
                </td>
                <td><%= info.getDataMovimentacao() %></td>
                <td><%= nomeCategoria.isEmpty() ? info.getCategoriaId() : nomeCategoria %></td>
                
                <td>
                    <a href="<%= request.getContextPath() %>/home/app/movimentacao_form.jsp?action=update&id=<%= info.getId() %>"
                       style="margin-right: 10px;">
                        ✏️ Alterar
                    </a>
                    <a href="<%= request.getContextPath() %>/home?action=delete&id=<%= info.getId() %>&task=movimentacao"
                       onclick="return confirm('Deseja realmente excluir a Movimentação \"<%= info.getDescricao() %>\" ?')"
                       style="color: #dc3545;">
                        🗑️ Excluir
                    </a>
                </td>
            </tr>
            <%
                }
            %>
        </table>
        
        <!-- Estatísticas -->
        <% 
            float totalReceitas = 0;
            float totalDespesas = 0;
            
            for(Movimentacao info : dados) {
                try {
                    Categoria cat = new Categoria();
                    cat.setId(info.getCategoriaId());
                    if (cat.load()) {
                        if ("receita".equals(cat.getTipo())) {
                            totalReceitas += info.getValor();
                        } else if ("despesa".equals(cat.getTipo())) {
                            totalDespesas += info.getValor();
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            float saldo = totalReceitas - totalDespesas;
        %>
        <div style="margin-top: 20px; padding: 15px; background-color: #e9ecef; border-radius: 5px; width: 90%;">
            <strong>Resumo Financeiro:</strong> 
            <span style="margin-left: 20px;">Total de Movimentações: <strong><%= dados.size() %></strong></span>
            <span style="margin-left: 20px; color: #28a745;">Receitas: <strong><%= formatoMoeda.format(totalReceitas) %></strong></span>
            <span style="margin-left: 20px; color: #dc3545;">Despesas: <strong><%= formatoMoeda.format(totalDespesas) %></strong></span>
            <span style="margin-left: 20px; color: <%= saldo >= 0 ? "#28a745" : "#dc3545" %>;">
                Saldo: <strong><%= formatoMoeda.format(saldo) %></strong>
            </span>
        </div>
        <% } %>
    </body>
</html>