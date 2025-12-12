package com.tourdulich.filter;

import com.tourdulich.model.NguoiDung;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        if (session == null || session.getAttribute("currentUser") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        NguoiDung user = (NguoiDung) session.getAttribute("currentUser");
        if (user.getRole() != NguoiDung.Role.ADMIN) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
    }
}