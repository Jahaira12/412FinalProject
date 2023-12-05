module com.example.scenebuildertesting {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;


    opens com.example.scenebuildertesting to javafx.fxml;
    exports com.example.scenebuildertesting;
}