package org.example;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.flywaydb.core.Flyway;
import org.json.JSONArray;
import org.json.JSONObject;

public class ImportJSONFromFileToDatabase {

    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/MTG_Cards";
        String username = "postgres";
        String password = "postgres";

        try (Connection conn = DriverManager.getConnection(url, username, password)) {

            String resetDB = "DROP TABLE IF EXISTS artists CASCADE;\n" +
                             "DROP TABLE IF EXISTS cards CASCADE;\n" +
                             "DROP TABLE IF EXISTS rarity CASCADE;\n" +
                             "DROP TABLE IF EXISTS set_data CASCADE;" +
                             "DROP TABLE IF EXISTS flyway_schema_history CASCADE;";

            PreparedStatement resetDBStmt = conn.prepareStatement(resetDB);
            resetDBStmt.executeUpdate();

            Flyway flyway = Flyway.configure()
                    .dataSource(url,username, password)
                    .locations("db/migrations")
                    .load();
            flyway.baseline();

            String createTableQuery = "CREATE TABLE IF NOT EXISTS cards ("
                    + "id SERIAL PRIMARY KEY,"
                    + "name TEXT,"
                    + "rarity TEXT,"
                    + "usd NUMERIC,"
                    + "usd_foil NUMERIC,"
                    + "eur NUMERIC,"
                    + "eur_foil NUMERIC,"
                    + "color_identity TEXT,"
                    + "artist TEXT,"
                    + "release_date DATE,"
                    + "set_name TEXT"
                    + ")";
            PreparedStatement createTableStmt = conn.prepareStatement(createTableQuery);
            createTableStmt.executeUpdate();

            try (BufferedReader reader = new BufferedReader(new FileReader("src/main/resources/oracle-cards-20230826210409.json"))) {
                StringBuilder jsonContent = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonContent.append(line);
                }

                JSONArray jsonArray = new JSONArray(jsonContent.toString());
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject cardObj = jsonArray.getJSONObject(i);

                    JSONObject pricesObj = cardObj.getJSONObject("prices");
                    BigDecimal usd = getNumericValue(pricesObj.optString("usd"));
                    BigDecimal usdFoil = getNumericValue(pricesObj.optString("usd_foil"));
                    BigDecimal eur = getNumericValue(pricesObj.optString("eur"));
                    BigDecimal eurFoil = getNumericValue(pricesObj.optString("eur_foil"));

                    if (usd != null || usdFoil != null || eur != null || eurFoil != null) {
                        String insertQuery = "INSERT INTO cards (name, rarity, usd, usd_foil, eur, eur_foil, color_identity, artist, release_date, set_name) "
                                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                        insertStmt.setString(1, cardObj.getString("name"));
                        insertStmt.setString(2, cardObj.getString("rarity"));
                        insertStmt.setBigDecimal(3, usd);
                        insertStmt.setBigDecimal(4, usdFoil);
                        insertStmt.setBigDecimal(5, eur);
                        insertStmt.setBigDecimal(6, eurFoil);

                        JSONArray colorIdentityArr = cardObj.optJSONArray("color_identity");
                        insertStmt.setString(7, formatColorIdentity(colorIdentityArr));

                        insertStmt.setString(8, cardObj.getString("artist"));
                        insertStmt.setDate(9, java.sql.Date.valueOf(cardObj.getString("released_at")));
                        insertStmt.setString(10, cardObj.getString("set_name"));

                        insertStmt.executeUpdate();
                    }
                }

                flyway.migrate();
                System.out.println("Data imported successfully!");

            } catch (IOException e) {
                e.printStackTrace();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static BigDecimal getNumericValue(String value) {
        return value.isEmpty() ? null : new BigDecimal(value);
    }

    private static String formatColorIdentity(JSONArray colorIdentityArr) {
        if (colorIdentityArr == null || colorIdentityArr.isEmpty()) {
            return "none";
        }
        String[] colorMapping = { "G", "R", "U", "W", "B", "C" };
        StringBuilder formattedColorIdentity = new StringBuilder();
        for (int i = 0; i < colorIdentityArr.length(); i++) {
            String color = colorIdentityArr.getString(i);
            switch (color) {
                case "G":
                    formattedColorIdentity.append("green");
                    break;
                case "R":
                    formattedColorIdentity.append("red");
                    break;
                case "U":
                    formattedColorIdentity.append("blue");
                    break;
                case "W":
                    formattedColorIdentity.append("white");
                    break;
                case "B":
                    formattedColorIdentity.append("black");
                    break;
                default:
                    formattedColorIdentity.append("unColored");
            }
            if (i < colorIdentityArr.length() - 1) {
                formattedColorIdentity.append("-");
            }
        }
        return formattedColorIdentity.toString();
    }
}

