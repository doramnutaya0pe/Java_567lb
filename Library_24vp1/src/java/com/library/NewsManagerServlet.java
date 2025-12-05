package com.library;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/news-manager")
public class NewsManagerServlet extends HttpServlet {
    //get запрос - Получение данных (чтение), отображение страниц, безопасные операции (не изменяющие данные)
    //post запрос - отправка данных(запись), изменение состояния на сервере, конфиденциальные операции
    
    //получение сессии и пользователя
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); //получаем текущую сессию пользователя
        User user = (User) session.getAttribute("user");
        
        //проверяем права модератора или администратора
        if (user == null || (!"MODERATOR".equals(user.getRole()) && !"ADMIN".equals(user.getRole()))) {
            response.sendRedirect("news-feed.jsp");
            return;
        }
        
        NewsDAO newsDAO = new NewsDAO(getServletContext()); //создает объект для работы с новостями, получает контекст приложения
        request.setAttribute("allNews", newsDAO.getAllNews()); //загружает все новости
        
        request.getRequestDispatcher("news-manager.jsp").forward(request, response); //перенаправляет
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        //проверка авторизации, как в get
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || (!"MODERATOR".equals(user.getRole()) && !"ADMIN".equals(user.getRole()))) {
            response.sendRedirect("news-feed.jsp");
            return;
        }
        
        //определение действия 
        String action = request.getParameter("action");
        NewsDAO newsDAO = new NewsDAO(getServletContext());
        
        try {
            if ("add".equals(action)) {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                
                //если поля пустые, то перенаправляет
                if (title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty()) {
                    
                    response.sendRedirect("news-manager?error=missing_fields");
                    return;
                }
                
                String newId = newsDAO.generateNewId(); //генерирует id
                News newNews = new News(newId, title, content, user.getFullName()); //создает новость
                
                if (newsDAO.addNews(newNews)) { //если успешно создалось
                    response.sendRedirect("news-manager?success=news_added"); //перенаправляет с параметром успеха
                } else {
                    response.sendRedirect("news-manager?error=add_failed");
                }
                
            } else if ("update".equals(action)) {
                //получает параметра
                String id = request.getParameter("id");
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                
                //проверяет пустые они или нет
                if (id == null || id.trim().isEmpty() ||
                    title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty()) {
                    
                    response.sendRedirect("news-manager?error=missing_fields");
                    return;
                }
                
                if (newsDAO.updateNews(id, title, content)) {
                    response.sendRedirect("news-manager?success=news_updated");
                } else {
                    response.sendRedirect("news-manager?error=update_failed");
                }
                
            } else if ("delete".equals(action)) {
                String id = request.getParameter("id");
                
                //id не пустой и удаление успешно
                if (id != null && newsDAO.deleteNews(id)) {
                    response.sendRedirect("news-manager?success=news_deleted");
                } else {
                    response.sendRedirect("news-manager?error=delete_failed");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("news-manager?error=server_error");
        }
    }
}
