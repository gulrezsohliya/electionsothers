package migrations;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Readimage {

    public static void main(String[] args) throws SQLException, IOException {
        Connection connectionsrc = null;
        Statement statementsrc = null;
        ResultSet rssrc = null;
        InputStream imageStream = null;
        OutputStream out = null;
        String filename = null;

        try {




            //SQL Server
//            String urlsrc = "jdbc:sqlserver://localhost:1433;encrypt=false;databaseName=S15_Reverse_Migration;";
//            String usernamesrc = "sa";
//            String passwordsrc = "Nicnet@10";
//
//            connectionsrc = DriverManager.getConnection(urlsrc, usernamesrc, passwordsrc);
//            statementsrc = connectionsrc.createStatement();
//
//            String sql = " SELECT CONCAT(ASSEMBLY_CONSTITUENCY_NUMBER,'-' ,PART_NUMBER ,'-', PART_SERIAL_NUMBER,'-',EPIC_NUMBER ) AS ACPARTSLNO, PHOTO FROM EROLL_DATA "
//                    + " WHERE 1 = 1 "
//                   // + " AND ASSEMBLY_CONSTITUENCY_NUMBER = 17 "
//                    +"  AND EPIC_NUMBER = 'SIF0196923'"
//                    + " ORDER BY ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER , PART_SERIAL_NUMBER ";
            //SQL Server
            

            //PostgreSQL
            String urlsrc = "jdbc:postgresql://10.179.0.75:5432/khadc";
            String usernamesrc = "khadc";
            String passwordsrc = "khadc@@@75";

            connectionsrc = DriverManager.getConnection(urlsrc, usernamesrc, passwordsrc);
            statementsrc = connectionsrc.createStatement();

            //String sql = " SELECT ACNO || '-' ||  PARTNO || '-' ||  SLNOINPART AS ACPARTSLNO, PHOTO FROM EROLLS.ELECTORALROLLS WHERE 1 = 1 AND EPIC_NUMBER ='BPH0574384' ORDER BY ACNO, PARTNO, SLNOINPART";
            String sql = " SELECT EPIC_NUMBER AS ACPARTSLNO, PHOTO FROM SOURCES.SOURCEELECTORALROLLS WHERE 1 = 1 AND EPIC_NUMBER ='HJF0630970' ";
            //PostgreSQL



            
            
            rssrc = statementsrc.executeQuery(sql);
            while (rssrc.next()) {

                //get data of first column from result set
                filename = rssrc.getString(1);

                System.out.println(" " + filename);

                out = new FileOutputStream(new File(".\\images\\" + filename + ".jpg"));
                //out = new FileOutputStream(new File(filename + ".jpg"));
                imageStream = rssrc.getBinaryStream(2);
                // initialize output stream with the file to create

                int c = 0;
                //write the contents from the input stream to the output stream
                while ((c = imageStream.read()) > -1) {
                    out.write(c);
                }
            }
        } catch (Exception e) {
            System.out.println("Exception " + e);
            e.printStackTrace();
           
        } finally {
            // close resources
            if (connectionsrc != null) {
                connectionsrc.close();
            }
            if (imageStream != null) {
                imageStream.close();
            }
            if (out != null) {
                out.close();
            }
            if (statementsrc != null) {
                statementsrc.close();
            }
        }

    }
}
