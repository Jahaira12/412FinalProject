package com.example.scenebuildertesting;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MainController {

    public RecipeAppDB db = RecipeAppDB.getInstance();
    @FXML
    public ListView<String> recipeName;
    @FXML
    public Button editProfile;

    public TextField searchBar;

    public void edit(ActionEvent event) {
        try {

            FXMLLoader fxmlLoader = new FXMLLoader(UserInfoController.class.getResource("userInfo.fxml"));
            fxmlLoader.load();
            Stage stage = (Stage) editProfile.getScene().getWindow();
            Scene scene = new Scene(fxmlLoader.getRoot());
            stage.setScene(scene);
            /*
            FXMLLoader loader = new FXMLLoader(getClass().getResource("userInfo.fxml"));
            Parent root = loader.load();

            // Get the controller of the UserInfo.fxml
            userInfoController userInfoController = loader.getController();

            // Pass any necessary data to the UserInfoController if needed
            // userInfoController.setData(...);

            Stage stage = (Stage) ((javafx.scene.Node) event.getSource()).getScene().getWindow();
            stage.setScene(new Scene(root));
            stage.show();

             */
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public void initialize(){
        ResultSet rs = db.getRecipeTable();
        try{
            while(rs.next()){
                String current = rs.getString("name");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                recipeName.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }
    }

    public void searching(ActionEvent actionEvent) {

        try{
            recipeName.getItems().clear();
            ResultSet rs = db.basicRecipeSearch(searchBar.getText());
            while(rs.next()){
                String current = rs.getString("name");
                ObservableList<String> list = FXCollections.observableArrayList(current);
                recipeName.getItems().addAll(list);
            }
        } catch (SQLException e){
            System.err.println(e.getMessage());
        }

    }
}