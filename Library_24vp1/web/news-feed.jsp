<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.User, com.library.Book, com.library.FavoriteDAO, com.library.BookDAO, java.util.*" %>
<%
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    User user = (User) userObj;
    FavoriteDAO favoriteDAO = new FavoriteDAO(application);
    BookDAO bookDAO = new BookDAO(application);
    
    //получаем ID избранных книг
    List<String> favoriteIds = favoriteDAO.getUserFavoriteIds(user.getUsername());
    List<Book> favoriteBooks = new ArrayList<>();
    
    // Получаем книги по ID
    for (String bookId : favoriteIds) {
        Book book = bookDAO.getBook(bookId);
        if (book != null) {
            favoriteBooks.add(book);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Мои книги</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background: #f0f8ff;
        }
        .header {
            text-align: center;
            background: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .nav {
            text-align: center;
            margin: 20px 0;
        }
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-primary { background: #007bff; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        
        .book-item {
            background: white;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
            border-left: 4px solid #4CAF50;
        }
        .book-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        .book-info {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .empty {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📚 Мои книги</h1>
        <p>Избранные книги пользователя <%= user.getFullName() %></p>
    </div>
    
    <div class="nav">
        <a href="profile.jsp"><button class="btn-secondary">← В кабинет</button></a>
        <a href="catalog.jsp"><button class="btn-primary">📖 В каталог</button></a>
    </div>
    
    <% if (favoriteBooks.isEmpty()) { %>
        <div class="empty">
            <p>У вас пока нет избранных книг</p>
            <p>Добавляйте книги в избранное из каталога</p>
        </div>
    <% } else { %>
        <h3>Книг в избранном: <%= favoriteBooks.size() %></h3>
        
        <% for (Book book : favoriteBooks) { %>
            <div class="book-item">
                <div class="book-title"><%= book.getTitle() %></div>
                <div class="book-info">
                    Автор: <%= book.getAuthor() %> | 
                    Жанр: <%= book.getGenre() %> | 
                    Год: <%= book.getYear() %>
                </div>
                <div>
                    <form action="favorite" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="bookId" value="<%= book.getId() %>">
                        <button type="submit" class="btn-danger">Удалить из избранного</button>
                    </form>
                </div>
            </div>
        <% } %>
    <% } %>
</body>
</html>
