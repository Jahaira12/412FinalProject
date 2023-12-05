package com.example.scenebuildertesting;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginController {
    RecipeAppDB db = RecipeAppDB.getInstance();

    @FXML
    private Label login_error_label;
    @FXML
    private TextField username_field;
    @FXML
    private Button login_button;

    @FXML
    public void onLoginButtonClick() throws IOException {

        // if Login successful, load main app screen else notify user.
        if(db.login(username_field.getText())){
            login_error_label.setVisible(false);
            FXMLLoader fxmlLoader = new FXMLLoader(MainController.class.getResource("main.fxml"));
            fxmlLoader.load();
            Stage stage = (Stage) login_button.getScene().getWindow();
            Scene scene = new Scene(fxmlLoader.getRoot());
            stage.setScene(scene);
        } else {
            login_error_label.setVisible(true);
        }
    }
}