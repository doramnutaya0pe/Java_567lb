<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.library.VisitCounter, com.library.NewsDAO, com.library.News, java.util.*, java.util.Date, java.text.SimpleDateFormat" %>
<%
    // Увеличиваем счетчик при каждом посещении
    VisitCounter.incrementVisitCount(application);
    int visitCount = VisitCounter.getVisitCount(application);
    
    // Получаем текущую дату и время сервера
    Date now = new Date();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
    String currentDateTime = dateFormat.format(now);
    
    // Создаем NewsDAO для загрузки новостей из файла
    NewsDAO newsDAO = new NewsDAO(application);
    List<News> allNews = newsDAO.getAllNews();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Новости библиотеки</title>
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
            margin-bottom: 30px;
        }
        .stats {
            background: white;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
            border: 1px solid #ddd;
        }
        .news-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .news-item {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .news-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        .news-title {
            color: #4CAF50;
            margin: 0 0 10px;
            font-size: 18px;
        }
        .news-date {
            color: #666;
            font-size: 12px;
            margin-bottom: 10px;
        }
        .news-text {
            color: #333;
            line-height: 1.5;
        }
        .news-author {
            color: #888;
            font-size: 12px;
            font-style: italic;
            margin-top: 10px;
        }
        .auth-buttons {
            text-align: center;
            margin: 30px 0;
        }
        .auth-buttons button {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin: 0 10px;
        }
        .btn-login {
            background: #4CAF50;
            color: white;
        }
        .btn-register {
            background: #2196F3;
            color: white;
        }
        .btn-login:hover {
            background: #45a049;
        }
        .btn-register:hover {
            background: #1976D2;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            color: #666;
            font-size: 14px;
        }
        .no-news {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>📚 Библиотека "Читай-Город"</h1>
        <p>Новости и события нашей библиотеки</p>
    </div>
    
    <!-- Статистика -->
    <div class="stats">
        <p><strong>Всего посещений:</strong> <%= visitCount %></p>
        <p><strong>Текущая дата и время:</strong> <%= currentDateTime %></p>
        <p><strong>Количество новостей:</strong> <%= allNews.size() %></p>
    </div>

    <!-- Кнопки входа/регистрации -->
    <div class="auth-buttons">
        <!-- Кнопки входа/регистрации -->
        <div class="auth-buttons">
            <a href="index.jsp"><button class="btn-login">🔑 Войти в систему</button></a><a href="register.jsp"><button class="btn-register">📝 Зарегистрироваться</button></a>
        </div>
    </div>

    <!-- Новостная лента -->
    <div class="news-container">
        <h2 style="text-align: center; color: #333; margin-bottom: 20px;">📰 Последние новости</h2>
        
        <% if (allNews.isEmpty()) { %>
            <div class="no-news">
                <p>Новостей пока нет. Загляните позже!</p>
            </div>
        <% } else { 
            for (News newsItem : allNews) { 
        %>
            <div class="news-item">
                <h3 class="news-title"><%= newsItem.getTitle() %></h3>
                <div class="news-date">📅 <%= newsItem.getDate() %></div>
                <p class="news-text"><%= newsItem.getContent() %></p>
                <div class="news-author">Автор: <%= newsItem.getAuthor() %></div>
            </div>
        <% } 
        } %>
    </div>
</body>
</html>
