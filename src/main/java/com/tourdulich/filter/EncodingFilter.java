package com.tourdulich.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter(filterName = "EncodingFilter", urlPatterns = "/*")
public class EncodingFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String uri = httpRequest.getRequestURI();
        
        if (isStaticResource(uri)) {
            chain.doFilter(request, response);
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        chain.doFilter(request, response);
    }
    
    private boolean isStaticResource(String uri) {
        return uri.endsWith(".css") || 
               uri.endsWith(".js") || 
               uri.endsWith(".png") || 
               uri.endsWith(".jpg") || 
               uri.endsWith(".jpeg") || 
               uri.endsWith(".gif") || 
               uri.endsWith(".ico") || 
               uri.endsWith(".svg") ||
               uri.endsWith(".woff") ||
               uri.endsWith(".woff2") ||
               uri.endsWith(".ttf") ||
               uri.endsWith(".eot") ||
               uri.contains("/assets/");
    }

    @Override
    public void destroy() {
    }
}

