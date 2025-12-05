<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.User, com.library.News, java.util.*" %>
<%
    Object userObj = session.getAttribute("user");
    //не авторизован или (не содератор и не админ), то на регистрацию
    if (userObj == null || (!"MODERATOR".equals(((User)userObj).getRole()) && !"ADMIN".equals(((User)userObj).getRole()))) {
        response.sendRedirect("news-feed.jsp");
        return;
    }
    
    List<News> allNews = (List<News>) request.getAttribute("allNews"); //получаем список новостей
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    
    //получаем ID новости для редактирования (если есть)
    String editId = request.getParameter("edit");
    News newsToEdit = null;
    if (editId != null && !editId.isEmpty()) {
        for (News news : allNews) {
            if (news.getId().equals(editId)) {
                newsToEdit = news;
                break;
            }
        }
    }
    
    //получаем ID новости для удаления (если есть)
    String deleteId = request.getParameter("delete");
    News newsToDelete = null;
    if (deleteId != null && !deleteId.isEmpty()) {
        for (News news : allNews) {
            if (news.getId().equals(deleteId)) {
                newsToDelete = news;
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Управление новостями</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .header {
            background: #28a745;
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
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
        .btn-success { background: #28a745; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: black; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-secondary { background: #6c757d; color: white; }
        
        .news-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #343a40;
            color: white;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .success { color: #28a745; padding: 10px; background: #d4edda; border-radius: 5px; }
        .error { color: #dc3545; padding: 10px; background: #f8d7da; border-radius: 5px; }
        .form-popup {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 500px;
            margin: 20px auto;
        }
        .overlay {
            display: none;
        }
        .news-content {
            max-height: 100px;
            overflow-y: auto;
            font-size: 14px;
            color: #666;
            line-height: 1.4;
        }
        .news-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        .news-meta {
            font-size: 12px;
            color: #888;
            margin-top: 5px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }
        .confirm-dialog {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px auto;
            text-align: center;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 500px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📰 Управление новостями</h1>
    </div>
    
    <div class="nav">
        <a href="profile.jsp"><button class="btn-secondary">← В кабинет</button></a>
        <a href="news-feed.jsp"><button class="btn-success">👁️ Просмотр новостей</button></a>
        <% if ("ADMIN".equals(((User)userObj).getRole())) { %>
            <a href="admin"><button class="btn-warning">👑 Панель администратора</button></a>
        <% } %>
        <a href="index.jsp"><button class="btn-secondary">На главную</button></a>
    </div>
    
    <% if (success != null) { %>
        <div class="success">
            <% 
                if ("news_added".equals(success)) out.print("✅ Новость успешно добавлена!");
                else if ("news_updated".equals(success)) out.print("✅ Новость успешно обновлена!");
                else if ("news_deleted".equals(success)) out.print("✅ Новость успешно удалена!");
            %>
        </div>
    <% } %>
    
    <% if (error != null) { %>
        <div class="error">
            <% 
                if ("missing_fields".equals(error)) out.print("❌ Заполните все обязательные поля!");
                else if ("add_failed".equals(error)) out.print("❌ Ошибка при добавлении новости!");
                else if ("update_failed".equals(error)) out.print("❌ Ошибка при обновлении новости!");
                else if ("delete_failed".equals(error)) out.print("❌ Ошибка при удалении новости!");
                else if ("server_error".equals(error)) out.print("❌ Ошибка сервера!");
            %>
        </div>
    <% } %>
    
    <!-- Если есть новость для удаления - показываем подтверждение -->
    <% if (newsToDelete != null) { %>
        <div class="confirm-dialog">
            <h3>⚠️ Подтверждение удаления</h3>
            <p><strong>Вы действительно хотите удалить новость?</strong></p>
            <p><strong>ID:</strong> #<%= newsToDelete.getId() %></p>
            <p><strong>Заголовок:</strong> <%= newsToDelete.getTitle() %></p>
            <p><strong>Автор:</strong> <%= newsToDelete.getAuthor() %></p>
            <p><strong>Дата:</strong> <%= newsToDelete.getDate() %></p>
            
            <div style="margin: 20px 0;">
                <form action="news-manager" method="post" style="display: inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= newsToDelete.getId() %>">
                    <button type="submit" class="btn-danger">✅ Да, удалить</button>
                </form>
                
                <a href="news-manager"><button type="button" class="btn-secondary">❌ Нет, отмена</button></a>
            </div>
        </div>
    <% } %>
    
    <!-- Форма добавления/редактирования новости -->
    <% if (newsToEdit != null || newsToDelete == null) { %>
    <div class="form-popup">
        <h3 style="margin-top: 0; margin-bottom: 15px;">
            <% if (newsToEdit != null) { %>
                ✏️ Редактирование новости #<%= newsToEdit.getId() %>
            <% } else { %>
                ➕ Добавление новой новости
            <% } %>
        </h3>
        
        <form action="news-manager" method="post">
            <% if (newsToEdit != null) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= newsToEdit.getId() %>">
            <% } else { %>
                <input type="hidden" name="action" value="add">
            <% } %>
            
            <div class="form-group">
                <label for="title">Заголовок *</label>
                <input type="text" id="title" name="title" required 
                       placeholder="Введите заголовок новости"
                       value="<%= newsToEdit != null ? newsToEdit.getTitle() : "" %>">
            </div>
            
            <div class="form-group">
                <label for="content">Содержание *</label>
                <textarea id="content" name="content" required 
                          placeholder="Введите текст новости..."><%= newsToEdit != null ? newsToEdit.getContent() : "" %></textarea>
            </div>
            
            <div style="text-align: center; margin-top: 20px;">
                <button type="submit" class="btn-success">
                    <% if (newsToEdit != null) { %>
                        Сохранить изменения
                    <% } else { %>
                        Добавить новость
                    <% } %>
                </button>
                
                <% if (newsToEdit != null) { %>
                    <a href="news-manager"><button type="button" class="btn-secondary">Отмена</button></a>
                <% } else { %>
                    <button type="reset" class="btn-secondary">Очистить</button>
                <% } %>
            </div>
        </form>
    </div>
    <% } %>
    
    <div class="news-table">
        <h2 style="padding: 20px; margin: 0;">Список новостей</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Заголовок</th>
                    <th>Содержание</th>
                    <th>Автор</th>
                    <th>Дата</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody>
                <% for (News newsItem : allNews) { %>
                <tr>
                    <td><strong>#<%= newsItem.getId() %></strong></td>
                    <td>
                        <div class="news-title"><%= newsItem.getTitle() %></div>
                    </td>
                    <td>
                        <div class="news-content"><%= newsItem.getContent() %></div>
                    </td>
                    <td><%= newsItem.getAuthor() %></td>
                    <td><%= newsItem.getDate() %></td>
                    <td>
                        <a href="news-manager?edit=<%= newsItem.getId() %>">
                            <button class="btn-primary">Редактировать</button>
                        </a>
                        
                        <a href="news-manager?delete=<%= newsItem.getId() %>">
                            <button class="btn-danger">Удалить</button>
                        </a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
