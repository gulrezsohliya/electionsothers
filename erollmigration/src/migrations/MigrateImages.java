/*
code to update image only from Sql Server to Postgres
 */
package migrations;

import java.sql.*;

public class MigrateImages {

    public static void main(String[] args) {
        // SQL Server connection parameters
        String sqlServerUrl = "jdbc:sqlserver://localhost:1433;databaseName=S15_Reverse_Migration;encrypt=false";
        String sqlServerUser = "sa";
        String sqlServerPassword = "Nicnet@10";

        // PostgreSQL connection parameters
        String postgresUrl = "jdbc:postgresql://localhost:5432/elections";
        String postgresUser = "elections";
        String postgresPassword = "elections";

        Connection sqlServerConn = null;
        Connection postgresConn = null;
        PreparedStatement updateStmt = null;
        ResultSet resultSet = null;

        int sourceacno = -1;
        int sourcepartno = -1;

        int acno = -1;
        int partno = -1;
        int slnoinpart = -1;
        long count = 0;
        try {
            // Establish connection to SQL Server
            sqlServerConn = DriverManager.getConnection(sqlServerUrl, sqlServerUser, sqlServerPassword);

            // Establish connection to PostgreSQL
            postgresConn = DriverManager.getConnection(postgresUrl, postgresUser, postgresPassword);

            // Disable auto-commit for transaction management
            postgresConn.setAutoCommit(false);

            // Query to retrieve data from SQL Server
            String selectQuery = "SELECT ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER, PART_SERIAL_NUMBER, PHOTO FROM EROLL_DATA_13 WHERE 1 = 1 ";

            if (sourceacno > 0) {
                selectQuery += " AND ASSEMBLY_CONSTITUENCY_NUMBER = " + sourceacno;
            }
            if (sourcepartno > 0) {
                selectQuery += " AND PART_NUMBER = " + sourcepartno;
            }

            selectQuery += " ORDER BY ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER, PART_SERIAL_NUMBER ";
            Statement selectStmt = sqlServerConn.createStatement();
            resultSet = selectStmt.executeQuery(selectQuery);

            // Query to insert or update data in PostgreSQL
            String updateQuery = "UPDATE SOURCES.SOURCEELECTORALROLLS SET PHOTO =? WHERE ASSEMBLY_CONSTITUENCY_NUMBER =? AND PART_NUMBER =? AND PART_SERIAL_NUMBER = ?";

            updateStmt = postgresConn.prepareStatement(updateQuery);

            // Process each row from SQL Server and insert/update into PostgreSQL
            while (resultSet.next()) {
                acno = resultSet.getInt("ASSEMBLY_CONSTITUENCY_NUMBER");
                partno = resultSet.getInt("PART_NUMBER");
                slnoinpart = resultSet.getInt("PART_SERIAL_NUMBER");
                byte[] photo = resultSet.getBytes("photo");
                
                acno = 1;

                
                
                
                updateStmt.setBytes(1, photo);
                updateStmt.setInt(2, acno);
                updateStmt.setInt(3, partno);
                updateStmt.setInt(4, slnoinpart);
                updateStmt.addBatch();

                System.out.println("Image Transfer in progress " + ++count + "  AC : " + acno + " PART NO : " + partno + " SLNOINPART " + slnoinpart);

            }

            // Execute batch insert/update
            updateStmt.executeBatch();

            // Commit the transaction
            postgresConn.commit();
            System.out.println("Data transfer completed successfully.");

        } catch (BatchUpdateException bue) {
            System.err.println("BatchUpdateException: " + bue.getMessage());
            for (Throwable e : bue) {
                System.err.println("Cause: " + e);
            }
            // Rollback transaction in case of error
            if (postgresConn != null) {
                try {
                    postgresConn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Rollback transaction in case of error
            if (postgresConn != null) {
                try {
                    postgresConn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }

        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (updateStmt != null) {
                    updateStmt.close();
                }
                if (sqlServerConn != null) {
                    sqlServerConn.close();
                }
                if (postgresConn != null) {
                    postgresConn.close();
                }
            } catch (SQLException closeEx) {
                closeEx.printStackTrace();
            }
        }
    }
}
