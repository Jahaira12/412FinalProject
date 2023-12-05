package com.example.scenebuildertesting;

import java.sql.*;
import java.util.Properties;

public class RecipeAppDB {
    private static RecipeAppDB instance;
    private RecipeAppDB(){}
    public static RecipeAppDB getInstance(){
        if (instance == null) {
            instance = new RecipeAppDB();
        }
        return instance;
    }

    private Connection conn = null;
    private int userID = 0;
    public String username = "";
    String dbserver = "localhost";
    String port = "8888";
    String db = "recipe_app_db";
    String user = "app_access";
    String pass = "app_password";
    //String dbURL = "jdbc:postgresql:" + dbserver + ":" + port + ":" + db + "?user=" + user + "&password=" + pass;
    String dbURL = "jdbc:postgresql://" + dbserver + ":" + port + "/" + db;
    private void connect() {
        try {
            Properties params = new Properties();
            params.put("user", user);
            params.put("password", pass);
            conn = DriverManager.getConnection(dbURL, params);
        } catch (SQLException ex) {
            System.err.println("Unable to connect to to database");
            System.err.println(ex.getMessage());
        }
    }

    private void disconnect() {
        try {
            conn.close();
        } catch (SQLException ex) {
            System.err.println(ex.getMessage());
        }
    }

    // Connects to database and checks if username is a valid user.
    //   Keeps connection open if valid, closes connection if not
    //   Returns true if login successful and false if not
    public boolean login(String username){
        connect();
        ResultSet resultSet = null;
        String sql = "SELECT get_userid(?)";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            resultSet = stmt.executeQuery();
            while (resultSet.next()){
                userID = resultSet.getInt(1);
                this.username = username;
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        if (userID < 1){
            disconnect();
            return false;
        } else {
            return true;
        }
    }

    public void logout(){
        disconnect();
        userID = -1;
    }

    public ResultSet getAllergensToAvoid(){
        ResultSet resultSet = null;
        String sql = "SELECT get_allergens_to_avoid(?)";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        return resultSet;
    }

    public ResultSet getUsersTable(){
        ResultSet resultSet = null;
        String sql = "SELECT * FROM users";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            //stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return resultSet;
    }
    public ResultSet getRecipeTable(){
        ResultSet resultSet = null;
        String sql = "SELECT * FROM recipe";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            //stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return resultSet;
    }
    public ResultSet getRatingTable(){
        ResultSet resultSet = null;
        String sql = "SELECT * FROM rating";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            //stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return resultSet;
    }
    public ResultSet getPantryTable(){
        ResultSet resultSet = null;
        //String sql = "SELECT * FROM pantry WHERE user_id = " + userID;
        String sql = "SELECT name, stock_level, pantry.ing_id FROM pantry JOIN ingredient ON pantry.ing_id = ingredient.ing_id WHERE user_id = " + userID;
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            //stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return resultSet;
    }
    public ResultSet getIngredientTable(){
        ResultSet resultSet = null;
        String sql = "SELECT * FROM ingredient";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            //stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return resultSet;
    }

    public ResultSet basicRecipeSearch(String searchText){
        ResultSet resultSet = null;
        String sql = "SELECT * FROM recipe WHERE name like '%" + searchText + "%'";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            resultSet = stmt.executeQuery();
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        return resultSet;
    }

    public void updateAllergensToAvoid(String allergens){
        //ResultSet resultSet = null;
        String sql = "SELECT update_allergens_to_avoid(?, ?)";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            stmt.setString(2, allergens);
            stmt.executeQuery();
            //resultSet = stmt.executeQuery();
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        //return resultSet;
    }

    public void updateCategoriesToAvoid(String categories){
        //ResultSet resultSet = null;
        String sql = "SELECT update_categories_to_avoid(?, ?)";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            stmt.setString(2, categories);
            stmt.executeQuery();
            //resultSet = stmt.executeQuery();
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        //return resultSet;
    }

    /*
    public ResultSet storedFunctionMethod(int userID){
        ResultSet resultSet = null;
        String sql = "SELECT get_allergens_to_avoid(?) AS result";
        try{
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            resultSet = stmt.executeQuery();
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        return resultSet;
    }
     */


}



