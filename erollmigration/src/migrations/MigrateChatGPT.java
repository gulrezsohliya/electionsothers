/*
 code to migrate all data from Sql Server to Postgres
 optimized for speed using batching
*/
package migrations;

import java.sql.*;

public class MigrateChatGPT {

    private static final int BATCH_SIZE = 2000;

    public static void main(String[] args) {

        // SQL Server connection parameters
        String sqlServerUrl = "jdbc:sqlserver://localhost:1433;databaseName=S15_2026;encrypt=false";
        String sqlServerUser = "sa";
        String sqlServerPassword = "Nicnet@10";

        // PostgreSQL connection parameters
        // NOTE: reWriteBatchedInserts=true added (Point 3)
        String postgresUrl = "jdbc:postgresql://10.179.0.75:5432/ghadc?reWriteBatchedInserts=true";
        String postgresUser = "ghadc";
        String postgresPassword = "ghadc";

        Connection sqlServerConn = null;
        Connection postgresConn = null;
        PreparedStatement statementPG = null;
        ResultSet resultSet = null;

        long count = 0;

        try {
            // 1️⃣ Connect to SQL Server
            sqlServerConn = DriverManager.getConnection(
                    sqlServerUrl, sqlServerUser, sqlServerPassword);

            // 2️⃣ Connect to PostgreSQL
            postgresConn = DriverManager.getConnection(
                    postgresUrl, postgresUser, postgresPassword);

            // 3️⃣ Disable auto-commit (Point 2)
            postgresConn.setAutoCommit(false);

            int sourceacno = 41;

            String selectQuery =
                    " SELECT EPIC_ID, NULL AS PROCESS_TYPE, VOTER_EPIC EPIC_NUMBER, " +
                    " VOTER_FNAME APPLICANT_FIRST_NAME, NULL AS APPLICANT_FIRST_NAME_L1, " +
                    " VOTER_LNAME APPLICANT_LAST_NAME, NULL AS APPLICANT_LAST_NAME_L1, " +
                    " ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER, PART_SERIAL_NUMBER, " +
                    " SECTION_NO, [[VOTER_AGE]]] AGE, VOTER_GENDER GENDER, " +
                    " RELATION_TYPE, VOTER_RELATION_NAME RELATION_NAME, " +
                    " NULL AS RELATION_NAME_L1, HOUSE_NUMBER, DOB, " +
                    " NULL AS HOUSE_NO_OLD, 'N' AS STATUS_TYPE, " +
                    " VOTER_RELATION_LNAME RELATION_L_NAME, NULL AS RLN_L_NM_V1, " +
                    " IS_ACTIVE, 0 AS REVISION_NO, NULL AS NOTIONAL_HNO, " +
                    " HOUSE_NUMBER_L1, 'N' AS MOVED, 'Y' AS ISADCVOTER, PHOTO " +
                    " FROM EROLL_DATA WHERE ASSEMBLY_CONSTITUENCY_NUMBER = " + sourceacno +
                    " ORDER BY ASSEMBLY_CONSTITUENCY_NUMBER, PART_NUMBER, PART_SERIAL_NUMBER ";

            Statement selectStmt = sqlServerConn.createStatement();
            resultSet = selectStmt.executeQuery(selectQuery);

            String insertQuery =
                    " INSERT INTO SOURCES.SOURCEELECTORALROLLS ( " +
                    " EPIC_ID, PROCESS_TYPE, EPIC_NUMBER, APPLICANT_FIRST_NAME, " +
                    " APPLICANT_FIRST_NAME_L1, APPLICANT_LAST_NAME, " +
                    " APPLICANT_LAST_NAME_L1, ASSEMBLY_CONSTITUENCY_NUMBER, " +
                    " PART_NUMBER, PART_SERIAL_NUMBER, SECTION_NO, AGE, " +
                    " GENDER, RELATION_TYPE, RELATION_NAME, RELATION_NAME_L1, " +
                    " HOUSE_NUMBER, DOB, HOUSE_NO_OLD, STATUS_TYPE, " +
                    " RELATION_L_NAME, RLN_L_NM_V1, IS_ACTIVE, REVISION_NO, " +
                    " NOTIONAL_HNO, HOUSE_NUMBER_L1, MOVED, ISADCVOTER, PHOTO ) " +
                    " VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

            statementPG = postgresConn.prepareStatement(insertQuery);

            // 4️⃣ Batch insert loop (Point 1 + 4)
            while (resultSet.next()) {

                statementPG.setLong(1, resultSet.getLong("EPIC_ID"));
                statementPG.setString(2, clean(resultSet.getString("PROCESS_TYPE")));
                statementPG.setString(3, clean(resultSet.getString("EPIC_NUMBER")));
                statementPG.setString(4, clean(resultSet.getString("APPLICANT_FIRST_NAME")));
                statementPG.setString(5, clean(resultSet.getString("APPLICANT_FIRST_NAME_L1")));
                statementPG.setString(6, clean(resultSet.getString("APPLICANT_LAST_NAME")));
                statementPG.setString(7, clean(resultSet.getString("APPLICANT_LAST_NAME_L1")));
                statementPG.setInt(8, resultSet.getInt("ASSEMBLY_CONSTITUENCY_NUMBER"));
                statementPG.setInt(9, resultSet.getInt("PART_NUMBER"));
                statementPG.setInt(10, resultSet.getInt("PART_SERIAL_NUMBER"));
                statementPG.setInt(11, resultSet.getInt("SECTION_NO"));
                statementPG.setInt(12, resultSet.getInt("AGE"));
                statementPG.setString(13, clean(resultSet.getString("GENDER")));
                statementPG.setString(14, clean(resultSet.getString("RELATION_TYPE")));
                statementPG.setString(15, clean(resultSet.getString("RELATION_NAME")));
                statementPG.setString(16, clean(resultSet.getString("RELATION_NAME_L1")));
                statementPG.setString(17, clean(resultSet.getString("HOUSE_NUMBER")));
                statementPG.setString(18, clean(resultSet.getString("DOB")));
                statementPG.setString(19, clean(resultSet.getString("HOUSE_NO_OLD")));
                statementPG.setString(20, clean(resultSet.getString("STATUS_TYPE")));
                statementPG.setString(21, clean(resultSet.getString("RELATION_L_NAME")));
                statementPG.setString(22, clean(resultSet.getString("RLN_L_NM_V1")));
                statementPG.setString(23, clean(resultSet.getString("IS_ACTIVE")));
                statementPG.setInt(24, resultSet.getInt("REVISION_NO"));
                statementPG.setInt(25, resultSet.getInt("NOTIONAL_HNO"));
                statementPG.setString(26, clean(resultSet.getString("HOUSE_NUMBER_L1")));
                statementPG.setString(27, clean(resultSet.getString("MOVED")));
                statementPG.setString(28, clean(resultSet.getString("ISADCVOTER")));
                statementPG.setBytes(29, resultSet.getBytes("PHOTO"));

                statementPG.addBatch();
                count++;

                if (count % BATCH_SIZE == 0) {
                    statementPG.executeBatch();
                    postgresConn.commit();
                    statementPG.clearBatch();

                    // progress log outside tight loop
                    System.out.println("Rows committed : " + count);
                }
            }

            // final batch
            statementPG.executeBatch();
            postgresConn.commit();

            System.out.println("Migration completed. Total rows : " + count);

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (postgresConn != null) postgresConn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (statementPG != null) statementPG.close();
                if (sqlServerConn != null) sqlServerConn.close();
                if (postgresConn != null) postgresConn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private static String clean(String s) {
        return s == null ? null : s.replace("\u0000", "").trim();
    }
}
