package com.library;

import java.util.*;
import java.io.*;
import javax.servlet.*;

public class FavoriteDAO {
    private static final String FAVORITES_FILE = "favorites.dat";
    private List<Favorite> favorites = new ArrayList<>(); //список книг в избранном
    private ServletContext context;
    
    public FavoriteDAO(ServletContext context) {
        this.context = context;
        loadFavorites();
    }
    
    //добавить в избранное
    public boolean addFavorite(String username, String bookId) {
        //проверяем, нет ли уже
        for (Favorite fav : favorites) {
            if (fav.getUsername().equals(username) && fav.getBookId().equals(bookId)) {
                return false;
            }
        }
        
        favorites.add(new Favorite(username, bookId));
        saveFavorites();
        return true;
    }
    
    //удалить из избранного
    public boolean removeFavorite(String username, String bookId) {
        for (int i = 0; i < favorites.size(); i++) {
            Favorite fav = favorites.get(i);
            if (fav.getUsername().equals(username) && fav.getBookId().equals(bookId)) {
                favorites.remove(i);
                saveFavorites();
                return true;
            }
        }
        return false;
    }
    
    //получить ID избранных книг пользователя
    public List<String> getUserFavoriteIds(String username) {
        List<String> ids = new ArrayList<>();
        for (Favorite fav : favorites) {
            if (fav.getUsername().equals(username)) {
                ids.add(fav.getBookId());
            }
        }
        return ids;
    }
    
    //проверить, в избранном ли книга
    public boolean isFavorite(String username, String bookId) {
        for (Favorite fav : favorites) {
            if (fav.getUsername().equals(username) && fav.getBookId().equals(bookId)) {
                return true;
            }
        }
        return false;
    }
    
    //заргрузка избранного
    private void loadFavorites() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + FAVORITES_FILE);
            File file = new File(filePath);
            if (file.exists()) {
                try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(file))) {
                    favorites = (List<Favorite>)ois.readObject();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    //сохранение избранного
    private void saveFavorites() {
        try {
            String filePath = context.getRealPath("/WEB-INF/" + FAVORITES_FILE);
            File file = new File(filePath);
            
            File parentDir = file.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }
            
            try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(file))) {
                oos.writeObject(favorites);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
