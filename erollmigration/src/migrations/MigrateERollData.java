/*
code to migrate all data from Sql Server to Postgres
 */
package migrations;

import java.sql.*;

public class MigrateERollData {

    public static void main(String[] args) {
        // SQL Server connection parameters
        String sqlServerUrl = "jdbc:sqlserver://localhost:1433;databaseName=S15_Reverse_Migration;encrypt=false";
        String sqlServerUser = "sa";
        String sqlServerPassword = "Nicnet@10";

        // PostgreSQL connection parameters
        String postgresUrl = "jdbc:postgresql://10.179.0.75:5432/khadc";
        String postgresUser = "khadc";
        String postgresPassword = "khadc@@@75";


//        String postgresUrl = "jdbc:postgresql://localhost:5432/khadc";
//        String postgresUser = "khadc";
//        String postgresPassword = "khadc";

        Connection sqlServerConn = null;
        Connection postgresConn = null;
        PreparedStatement statementPG = null;
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
            
            sourceacno = 29;
            String selectQuery = " SELECT EPIC_ID, NULL AS PROCESS_TYPE, EPIC_NUMBER, APPLICANT_FIRST_NAME, NULL AS  APPLICANT_FIRST_NAME_L1, APPLICANT_LAST_NAME, NULL AS APPLICANT_LAST_NAME_L1, "
                    + " ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER, PART_SERIAL_NUMBER, SECTION_NO, AGE, GENDER, RELATION_TYPE, RELATION_NAME, NULL AS RELATION_NAME_L1, HOUSE_NUMBER, "
                    + " DOB, NULL AS HOUSE_NO_OLD, 'N' AS STATUS_TYPE, RELATION_L_NAME, NULL AS RLN_L_NM_V1, IS_ACTIVE, 0 AS REVISION_NO, NULL AS NOTIONAL_HNO, HOUSE_NUMBER_L1, 'N' AS  MOVED, 'Y' AS ISADCVOTER, PHOTO "
                    + " FROM EROLL_DATA WHERE 1= 1  ";
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
            String insertQuery = "INSERT INTO SOURCES.SOURCEELECTORALROLLS  "
                    + " (EPIC_ID, PROCESS_TYPE, EPIC_NUMBER, APPLICANT_FIRST_NAME, APPLICANT_FIRST_NAME_L1, APPLICANT_LAST_NAME, APPLICANT_LAST_NAME_L1, "
                    + " ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER, PART_SERIAL_NUMBER, SECTION_NO, AGE, GENDER, RELATION_TYPE, RELATION_NAME, RELATION_NAME_L1, HOUSE_NUMBER, "
                    + " DOB, HOUSE_NO_OLD, STATUS_TYPE, RELATION_L_NAME, RLN_L_NM_V1, IS_ACTIVE, REVISION_NO, NOTIONAL_HNO, HOUSE_NUMBER_L1, MOVED, ISADCVOTER, PHOTO )"
                    + " VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

            statementPG = postgresConn.prepareStatement(insertQuery);
            // Process each row from SQL Server and insert/update into PostgreSQL
            while (resultSet.next()) {
                statementPG.setLong(1, resultSet.getLong("EPIC_ID"));
                statementPG.setString(2, resultSet.getString("PROCESS_TYPE"));
                statementPG.setString(3, resultSet.getString("EPIC_NUMBER"));
                statementPG.setString(4, resultSet.getString("APPLICANT_FIRST_NAME"));
                statementPG.setString(5, resultSet.getString("APPLICANT_FIRST_NAME_L1"));
                statementPG.setString(6, resultSet.getString("APPLICANT_LAST_NAME"));
                statementPG.setString(7, resultSet.getString("APPLICANT_LAST_NAME_L1"));
                statementPG.setInt(8, resultSet.getInt("ASSEMBLY_CONSTITUENCY_NUMBER"));
                statementPG.setInt(9, resultSet.getInt("PART_NUMBER"));
                statementPG.setInt(10, resultSet.getInt("PART_SERIAL_NUMBER"));
                statementPG.setInt(11, resultSet.getInt("SECTION_NO"));
                statementPG.setInt(12, resultSet.getInt("AGE"));
                statementPG.setString(13, resultSet.getString("GENDER"));
                statementPG.setString(14, resultSet.getString("RELATION_TYPE"));
                statementPG.setString(15, resultSet.getString("RELATION_NAME"));
                statementPG.setString(16, resultSet.getString("RELATION_NAME_L1"));
                statementPG.setString(17, resultSet.getString("HOUSE_NUMBER"));
                statementPG.setString(18, resultSet.getString("DOB"));
                statementPG.setString(19, resultSet.getString("HOUSE_NO_OLD"));
                statementPG.setString(20, resultSet.getString("STATUS_TYPE"));
                statementPG.setString(21, resultSet.getString("RELATION_L_NAME"));
                statementPG.setString(22, resultSet.getString("RLN_L_NM_V1"));
                statementPG.setString(23, resultSet.getString("IS_ACTIVE"));
                statementPG.setInt(24, resultSet.getInt("REVISION_NO"));
                statementPG.setInt(25, resultSet.getInt("NOTIONAL_HNO"));
                statementPG.setString(26, resultSet.getString("HOUSE_NUMBER_L1"));
                statementPG.setString(27, resultSet.getString("MOVED"));
                statementPG.setString(28, resultSet.getString("ISADCVOTER"));
                statementPG.setBytes(29, resultSet.getBytes("PHOTO"));
                statementPG.addBatch();

                System.out.println("Data Transfer in progress : " + ++count + "  AC : " + resultSet.getInt("ASSEMBLY_CONSTITUENCY_NUMBER") + " PART NO : " + resultSet.getInt("PART_NUMBER") + " SLNOINPART " + resultSet.getInt("PART_SERIAL_NUMBER"));

            }

            // Execute batch insert/update
            statementPG.executeBatch();

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
                if (statementPG != null) {
                    statementPG.close();
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
