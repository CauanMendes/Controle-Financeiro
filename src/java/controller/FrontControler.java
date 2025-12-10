package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import logtrack.ExceptionLogTrack;
import java.sql.SQLException;

import model.Categoria;
import model.Movimentacao;
import model.Objetivo;
import model.Usuario;

public class FrontControler extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String task = request.getParameter("task");
        if (task == null) {
            task = "";
        }

        try {

            switch (task) {
                case "usuario":
                    doGetUsuarios(request, response);
                    break;
                case "logout":
                    doGetLogout(request, response);
                    break;
                case "movimentacao":
                    doGetMovimentacoes(request, response);
                    break;
                case "categoria":
                    doGetCategorias(request, response);
                    break;
                case "objetivo":
                    doGetObjetivos(request, response);
                    break;
                default:
                    doDefault(request, response);
            }

        } catch (Exception ex) {
            ExceptionLogTrack.getInstance().addLog(ex);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String task = request.getParameter("task");
        if (task == null) {
            task = "";
        }

        try {

            switch (task) {
                case "usuario":
                    doPostUsuarios(request, response);
                    break;
                case "login":
                    doPostLogin(request, response);
                    break;
                case "movimentacao":
                    doPostMovimentacoes(request, response);
                    break;
                case "categoria":
                    doPostCategorias(request, response);
                    break;
                case "objetivo":
                    doPostObjetivos(request, response);
                    break;
                default:
                    doDefault(request, response);
            }

        } catch (Exception ex) {
            ExceptionLogTrack.getInstance().addLog(ex);
        }
    }

    private void doGetUsuarios(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario u = new Usuario();
            u.setId(id);

            u.delete();
            
            HttpSession sessao = request.getSession(false);

        if (sessao != null) {

            sessao.removeAttribute("usuario");

            sessao.invalidate();
        }

        response.sendRedirect(request.getContextPath());


        }else{
            response.sendRedirect(request.getContextPath() + "/home/app/usuario.jsp");
        }

        
    }

    private void doGetLogout(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession sessao = request.getSession(false);

        if (sessao != null) {

            sessao.removeAttribute("usuario");

            sessao.invalidate();
        }

        response.sendRedirect(request.getContextPath());
    }

private void doPostUsuarios(HttpServletRequest request, HttpServletResponse response) throws Exception {
    try {
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String nome = request.getParameter("nome");
        String senha = request.getParameter("senha");
        String email = request.getParameter("email");
        
        // VALIDAÇÃO OBRIGATÓRIA DO ID
        if (idParam == null || idParam.trim().isEmpty()) {
            throw new Exception("ID é obrigatório");
        }
        
        int id = Integer.parseInt(idParam);
        
        Usuario u = new Usuario();
        
        if (action.equals("update")) {
            // UPDATE
            u.setId(id);
            u.load();
            
            // Verifica se email já existe (outro usuário)
            if (!u.getEmail().equals(email)) {
                Usuario temp = new Usuario();
                temp.setEmail(email);
                if (temp.loadByEmail() && temp.getId() != id) {
                    throw new Exception("Email já cadastrado para outro usuário");
                }
            }
            
            u.setNome(nome);
            u.setSenha(senha);
            u.setEmail(email);
            u.save();
            
        } else { // CREATE
            // CREATE - ID é obrigatório
            u.setId(id);
            
            // Verifica se ID já existe (agora obrigatório verificar antes)
            if (u.load()) {
                throw new Exception("ID " + id + " já está em uso. Escolha outro ID.");
            }
            
            // Verifica se email já existe
            Usuario usuarioComEmail = new Usuario();
            usuarioComEmail.setEmail(email);
            if (usuarioComEmail.loadByEmail()) {
                throw new Exception("Email já cadastrado no sistema");
            }
            
            // Cria novo usuário
            u.setNome(nome);
            u.setSenha(senha);
            u.setEmail(email);
            u.save();
        }
        
        response.sendRedirect(request.getContextPath() + "/home/app/usuario.jsp");
        
    } catch (NumberFormatException e) {
        response.sendRedirect(request.getContextPath() + 
                            "/home/erro_pagina.jsp?message=" + 
                            java.net.URLEncoder.encode("ID inválido. Deve ser um número.", "UTF-8"));
        
    } catch (SQLException e) {
        // Ainda mantemos tratamento SQL caso algo escape das validações
        handleSQLException(request, response, e);
        
    } catch (Exception e) {
        response.sendRedirect(request.getContextPath() + 
                            "/home/erro_pagina.jsp?message=" + 
                            java.net.URLEncoder.encode("Erro: " + e.getMessage(), "UTF-8"));
    }
}

private void handleSQLException(HttpServletRequest request, HttpServletResponse response, SQLException e) 
        throws IOException {
    
    String contextPath = request.getContextPath();
    String encodedMessage;
    
    if (e.getErrorCode() == 1062 || e.getMessage().contains("Duplicate entry")) {
        
        if (e.getMessage().contains("PRIMARY") || e.getMessage().contains("id")) {
            encodedMessage = java.net.URLEncoder.encode("ID já existe no banco de dados. Escolha outro ID.", "UTF-8");
        } else if (e.getMessage().contains("email")) {
            encodedMessage = java.net.URLEncoder.encode("Email já cadastrado no sistema. Use outro email.", "UTF-8");
        } else {
            encodedMessage = java.net.URLEncoder.encode("Dados duplicados no banco: " + e.getMessage(), "UTF-8");
        }
        
        response.sendRedirect(contextPath + "/home/erro_pagina.jsp?message=" + encodedMessage);
        
    } else {
        encodedMessage = java.net.URLEncoder.encode("Erro de banco de dados: " + e.getMessage(), "UTF-8");
        response.sendRedirect(contextPath + "/home/erro_pagina.jsp?message=" + encodedMessage);
    }
}
    
    
    private void doPostLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        // Buscar usuário pelo email
        Usuario usuario = new Usuario();
        usuario.setEmail(email);

        boolean status = usuario.loadByEmail(); // <-- precisa implementar esse método
        // para carregar o usuário pelo email

        System.out.println("Status" + status);
        System.out.println("senha" + usuario.validarSenha(senha));

        if (status && usuario.validarSenha(senha)) {

            // Reinicia sessão caso exista
            HttpSession sessao = request.getSession(false);
            if (sessao != null) {
                sessao.invalidate();
            }

            // Cria nova sessão
            sessao = request.getSession(true);
            sessao.setAttribute("usuario", "(" + usuario.getId() + ", " + usuario.getNome() + ", " + usuario.getEmail() + ")");

            // Sessão dura 7 dias
            sessao.setMaxInactiveInterval(60 * 60 * 24 * 7);

            // Cookie para lembrar email
            Cookie cookie = new Cookie("email", email);
            cookie.setMaxAge(60 * 60 * 24 * 7);
            response.addCookie(cookie);

            // Redireciona para o menu
            response.sendRedirect(request.getContextPath() + "/home/app/menu.jsp");

        } else {
            request.setAttribute("msg", "Email e/ou senha incorreto(s)");
            request.getRequestDispatcher("/home/login.jsp").forward(request, response);
        }
    }

    private void doGetMovimentacoes(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Movimentacao m = new Movimentacao();
            m.setId(id);
            m.delete();
        }

        response.sendRedirect(request.getContextPath() + "/home/app/movimentacao.jsp");
    }

    private void doPostMovimentacoes(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        int id = Integer.parseInt(request.getParameter("id"));
        String descricao = request.getParameter("descricao");
        float valor = Float.parseFloat(request.getParameter("valor"));
        String dataMovimentacao = request.getParameter("dataMovimentacao");
        int usuarioId = Integer.parseInt(request.getParameter("usuarioId"));
        int categoriaId = Integer.parseInt(request.getParameter("categoriaId"));

        Movimentacao m = new Movimentacao();

        m.setId(id);

        if (action.equals("update") && id > 0) {
            m.load(); // carrega dados antigos antes de atualizar
        }

        m.setDescricao(descricao);
        m.setValor(valor);
        m.setDataMovimentacao(dataMovimentacao);
        m.setUsuarioId(usuarioId);
        m.setCategoriaId(categoriaId);

        m.save();

        response.sendRedirect(request.getContextPath() + "/home/app/movimentacao.jsp");
    }

    private void doGetObjetivos(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Objetivo o = new Objetivo();
            o.setId(id);
            o.delete();
        }

        response.sendRedirect(request.getContextPath() + "/home/app/objetivo.jsp");
    }

    private void doPostObjetivos(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        int id = Integer.parseInt(request.getParameter("id"));
        String descricao = request.getParameter("descricao");
        float valor = Float.parseFloat(request.getParameter("valor"));
        String dataObjetivo = request.getParameter("dataObjetivo");
        int usuarioId = Integer.parseInt(request.getParameter("usuarioId"));

        Objetivo o = new Objetivo();
        o.setId(id);

        if (action.equals("update") && id > 0) {
            o.load(); // carrega dados antigos antes de atualizar
        }

        o.setDescricao(descricao);
        o.setValor(valor);
        o.setDataObjetivo(dataObjetivo);
        o.setUsuarioId(usuarioId);

        o.save();

        response.sendRedirect(request.getContextPath() + "/home/app/objetivo.jsp");
    }

    private void doGetCategorias(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Categoria c = new Categoria();
            c.setId(id);
            c.delete();
        }

        response.sendRedirect(request.getContextPath() + "/home/app/categoria.jsp");
    }

    private void doPostCategorias(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String action = request.getParameter("action");

        int id = Integer.parseInt(request.getParameter("id"));
        String nome = request.getParameter("nome");
        String tipo = request.getParameter("tipo");
        int usuarioId = Integer.parseInt(request.getParameter("usuarioId"));

        Categoria c = new Categoria();

        c.setId(id);

        if (action.equals("update") && id > 0) {
            c.load(); // carrega dados antigos antes de atualizar
        }

        c.setNome(nome);
        c.setTipo(tipo);
        c.setUsuarioId(usuarioId);

        c.save();

        response.sendRedirect(request.getContextPath() + "/home/app/categoria.jsp");
    }
    


    private void doDefault(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/home/login.jsp");
    }

}
