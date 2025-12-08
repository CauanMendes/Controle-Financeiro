package controller;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AutenticadorApp implements Filter {
    

    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        
        
        
            HttpServletRequest httpServletRequest = (HttpServletRequest) request;
            HttpServletResponse httpServletResponse = (HttpServletResponse) response;
            
            HttpSession sessao = httpServletRequest.getSession(false);
        
            if(sessao == null || sessao.getAttribute("usuario") == null ){
                httpServletRequest.setAttribute("msg", "faça o login!");
                httpServletRequest.getRequestDispatcher("/home/login.jsp").forward(request, response);
            }else{
                //se logado, continue
                chain.doFilter(request, response);
            }
            
       
    }


}
