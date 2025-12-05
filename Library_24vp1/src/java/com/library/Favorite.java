package com.library;

import java.io.Serializable;

public class Favorite implements Serializable {
    private String username;
    private String bookId;
    
    public Favorite(String username, String bookId) {
        this.username = username;
        this.bookId = bookId;
    }
    
    public String getUsername() { return username; }
    public String getBookId() { return bookId; }
}
