package com.library;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

public class News implements Serializable { //сериализация - процесс при которомобъекты класса могут быть преобразованы в в последовательность байтов и восставновленны из последовательности 
    private String id;
    private String title;
    private String content;
    private String date;
    private String author;
    
    public News(String id, String title, String content, String author) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.date = new SimpleDateFormat("dd.MM.yyyy HH:mm").format(new Date()); //форматирует текущую дату.применяет форматирование (к текущей дате)
    }
    
    // Геттеры
    public String getId() { return id; }
    public String getTitle() { return title; }
    public String getContent() { return content; }
    public String getDate() { return date; }
    public String getAuthor() { return author; }
    
    // Сеттеры
    public void setTitle(String title) { this.title = title; }
    public void setContent(String content) { this.content = content; }
    public void setDate(String date) { this.date = date; }
}
