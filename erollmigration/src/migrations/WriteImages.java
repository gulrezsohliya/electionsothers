import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class WriteImages {

    // JDBC URL, username, and password of PostgreSQL server
    private static final String url = "jdbc:postgresql://10.179.0.75:5432/khadc";
    private static final String user = "khadc";
    private static final String password = "khadc@@@75";

    // Method to insert an image into the database
    public static void main(String[] args) {

        try {

            // Load the PostgreSQL JDBC driver
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection(url, user, password);
            // Folder containing images
            String folderPath = "C:\\work\\elections\\uploadedimages\\";
            File folder = new File(folderPath);
            File[] listOfFiles = folder.listFiles();

            if (listOfFiles != null) {
                for (File file : listOfFiles) {
                    if (file.isFile()) {
                        //System.out.println("File Name : " + file.getName());
                        //System.out.println("Employee Code : " + file.getName().substring(0, 11));
                        File imageFile = new File(folderPath + "" + file.getName());
                        System.out.println("file " + folderPath + "\\" + file.getName());
                        FileInputStream fis = new FileInputStream(imageFile);
                       
                        
                        String sql = "UPDATE SOURCES.SOURCEELECTORALROLLS SET PHOTO = ?  WHERE EPIC_NUMBER = ?";
                        PreparedStatement statement = connection.prepareStatement(sql);
                        // Set the image data as a binary stream
                        statement.setBinaryStream(1, fis, (int) imageFile.length());
                        statement.setString(2, file.getName().substring(0, 10));

                        // Execute the query
                        int x = statement.executeUpdate();
                        if (x > 0) {
                            System.out.println("Image inserted successfully. " + file.getName().substring(0, 10));
                        } else {
                            System.out.println("Voter Not Found " + file.getName().substring(0, 10));
                        }
                    }
                }
            }
            System.out.println("End");
        } catch (Exception e) {
            System.out.println("Error");
            e.printStackTrace();
        }
    }

}