package com.library;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/favorite")
public class FavoriteServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        doGet(request, response); //вызываем тот же код
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        //если не зарегистрирован
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        //получение параметра активности
        String action = request.getParameter("action");
        String bookId = request.getParameter("bookId");
        
        FavoriteDAO favoriteDAO = new FavoriteDAO(getServletContext());
        
        if ("add".equals(action) && bookId != null) {
            favoriteDAO.addFavorite(user.getUsername(), bookId);
        } 
        else if ("remove".equals(action) && bookId != null) {
            favoriteDAO.removeFavorite(user.getUsername(), bookId);
        }
    }
}
