package com.example.scenebuildertesting;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.text.Text;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserInfoController {
    private RecipeAppDB db =RecipeAppDB.getInstance();
    @FXML
    public Text welcome_text;
    @FXML
    public TextArea allergens;
    public TextArea categories;
    public Button updateAllergens;
    public Button updateCategories;
    public Button addShopping;
    public CheckBox cb1, cb2, cb3, cb4, cb5, cb6, cb7, cb8, cb9;
    public TextField searchBar;
    CheckBox[] shoppingList = {cb1,cb2,cb3,cb4, cb5, cb6, cb7, cb8, cb9};
    int num = 0;
    public ListView<String> recipeName, servings, ingredients, stock, style;
    public ListView<Double> rating;

    @FXML
    public void initialize(){
        ResultSet rs = db.getRecipeTable();
        welcome_text.setText("Welcome Back " + db.username + "!");
        try{
            while(rs.next()){
                String current = rs.getString("name");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                recipeName.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        try{
            while(rs.next()){
                String current = rs.getString("servings");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                servings.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        try{
            while(rs.next()){
                String current = rs.getString("style");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                style.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        rs=db.getRatingTable();
        try{
            while(rs.next()){
                String current = rs.getString("avg_rating");
                ObservableList<Double> list = FXCollections.observableArrayList(Double.valueOf(current));
                System.out.println("Current rating: " + current);
                rating.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        rs=db.getPantryTable();
        try{
            while(rs.next()){
                String current = rs.getString("stock_level");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                stock.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        rs=db.getPantryTable();
        try{
            while(rs.next()){
                String current = rs.getString("name");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                ingredients.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
        rs=db.getAllergensToAvoid();
        try{
            while(rs.next()){
                String temp = "";
                temp = rs.getString(1) + temp;
                allergens.setText(temp);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
    }
    @FXML
    public void setAllergens(ActionEvent actionEvent){
        db.updateAllergensToAvoid(allergens.getText());
    }
    @FXML
    public void setCategories(ActionEvent actionEvent){
        db.updateCategoriesToAvoid(categories.getText());
    }
    public void checked(ActionEvent actionEvent){
        if(cb1.getOpacity()==1){
            cb1.setSelected(true);
        } else if(cb2.getOpacity()==1) {
            cb2.setSelected(true);
        }else if(cb3.getOpacity()==1) {
            cb3.setSelected(true);
        }else if(cb4.getOpacity()==1) {
            cb4.setSelected(true);
        }else if(cb5.getOpacity()==1) {
            cb5.setSelected(true);
        }else if(cb6.getOpacity()==1) {
            cb6.setSelected(true);
        }else if(cb7.getOpacity()==1) {
            cb7.setSelected(true);
        }else if(cb8.getOpacity()==1) {
            cb8.setSelected(true);
        }else if(cb9.getOpacity()==1) {
            cb9.setSelected(true);
        }
    }
    public boolean createCheckBox(ActionEvent actionEvent){
        String currCB = "cb1";
        if(cb1.getOpacity()==0){
            cb1.setText(searchBar.getText());
            cb1.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        } else if(cb2.getOpacity()==0) {
            cb2.setText(searchBar.getText());
            cb2.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }else if(cb3.getOpacity()==0) {
            cb3.setText(searchBar.getText());
            cb3.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }else if(cb4.getOpacity()==0) {
            cb4.setText(searchBar.getText());
            cb4.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }else if(cb5.getOpacity()==0) {
            cb5.setText(searchBar.getText());
            cb5.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }else if(cb6.getOpacity()==0) {
            cb6.setText(searchBar.getText());
            cb6.setOpacity(1);
            num++;
            return true;
        }else if(cb7.getOpacity()==0) {
            cb7.setText(searchBar.getText());
            cb7.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }else if(cb8.getOpacity()==0) {
            cb8.setText(searchBar.getText());
            cb8.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }else if(cb9.getOpacity()==0) {
            cb9.setText(searchBar.getText());
            cb9.setOpacity(1);
            num++;
            searchBar.setText("");
            return true;
        }
        /*while(num != 9){
            if(shoppingList[num].getOpacity()==0){
                shoppingList[num].setText(searchBar.getText());
                shoppingList[num].setOpacity(1);
                System.out.print(searchBar.getText());
                return true;
            }
            num++;
        }*/
        searchBar.setText("");
        return false;
    }
}