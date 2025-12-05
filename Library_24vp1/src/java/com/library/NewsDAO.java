package com.library;

import java.util.*;
import java.io.*;
import javax.servlet.*;
import java.text.SimpleDateFormat;

public class NewsDAO {
    private static final String NEWS_FILE = "news.dat"; //имя файла
    private Map<String, News> news = new HashMap<>(); //коллекция для хранения новостей
    private ServletContext context; //контекст приложения - позволяет получать пути к файлам внутри проекта
    
    //конструктор
    public NewsDAO(ServletContext context) {
        this.context = context; //сохраняет контекст 
        loadNews(); //загружает новости
        
        // Добавляем тестовые новости если файл пустой
        if (news.isEmpty()) {
            addTestNews();
            saveNews();
        }
    }
    
    //создает 3 тестовых новости
    private void addTestNews() {
        news.put("1", new News("1", "Открытие нового филиала", 
            "Рады сообщить об открытии нового филиала библиотеки в центре города.", "Администратор"));
        
        news.put("2", new News("2", "Новые поступления книг", 
            "В наш каталог добавлены новые книги от современных авторов.", "Библиотекарь"));
        
        news.put("3", new News("3", "Обновление онлайн-системы", 
            "Мы улучшили нашу онлайн-платформу. Теперь вы можете продлевать книги онлайн.", "Техподдержка"));
    }
    
    //возвращает все новости 
    public List<News> getAllNews() {
        return new ArrayList<>(news.values()); 
    }
    
    //послечение новости по id
    public News getNews(String id) {
        return news.get(id);
    }
    
    //добавление новости
    public boolean addNews(News newsItem) {
        if (news.containsKey(newsItem.getId())) { //проверяет существует ли ключ в коллекции
            return false;
        }
        news.put(newsItem.getId(), newsItem); //добавляет новость 
        saveNews();
        return true;
    }
    
    //обновляет новость
    public boolean updateNews(String id, String title, String content) {
        News newsItem = news.get(id);
        if (newsItem != null) {
            newsItem.setTitle(title); //обновляет заголовок
            newsItem.setContent(content); //обновляет содержание
            newsItem.setDate(new SimpleDateFormat("dd.MM.yyyy HH:mm").format(new Date())); //обновляет дату
            saveNews();
            return true;
        }
        return false;
    }
    
    //удаление новости
    public boolean deleteNews(String id) {
        if (news.containsKey(id)) {
            news.remove(id);
            saveNews();
            return true;
        }
        return false;
    }
    
    //генерация нового id
    public String generateNewId() {
        int maxId = 0;
        for (String id : news.keySet()) { //keySet - весь набор ключей в коддекции
            try {
                int numId = Integer.parseInt(id);
                if (numId > maxId) {
                    maxId = numId;
                }
            } catch (NumberFormatException e) {
                // Пропускаем нечисловые ID
            }
        }
        return String.valueOf(maxId + 1);
    }
    
    //для работы с файлом
    private void loadNews() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + NEWS_FILE); //формируем реальный путь
            File file = new File(filePath);
            if (file.exists()) { //если файл существует
                try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) { //превращаем байты в объект(чтение данных в виде байтов)
                    news = (Map<String, News>)ois.readObject(); //читает и приводит к типу коллекции
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //сохранение новости
    public void saveNews() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + NEWS_FILE);
            File file = new File(filePath);

            File parentDir = file.getParentFile(); //получает родительскую папку
            if (!parentDir.exists()) { //проверяет есть ли она
                parentDir.mkdirs(); //создает, если ее нет
            }

            try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file))) { //предъвращает объект в байты(читение данных в виде объектов)
                oos.writeObject(news); //запись в файл
            }
        } catch (IOException e) {
            e.printStackTrace();
        }   
    }
}
