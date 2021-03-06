---
layout: post
title: 'Clear database using Java and JDBC'
comments: true
tags:
 - clear_database
 - drop
 - jpa
 - java
 - ejb
 - testing
 - jdbc
 - junit
 - meta_data
 - rest_database
 - test
 - jndi
---

The following Java class can be used to clear a whole database or to drop all tables of a database. This functionality was frequently required during the development of the <a title="The Open Decision Repository project site" href="http://code.google.com/p/opendecisionrepository/">Open Decision Repository</a> and was created during my internship in the winter semester of 2010.

The class analyses the database structure and uses this information to delete each row one by one instead of using a truncate or <em>delete from x</em> statement. This was mandatory as referential integrity made it complicated to empty the database for testing and development.


{% highlight java %}
package nl.rug.search.odr;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * 
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
public class DatabaseCleaner {

    private static final Logger LOGGER = Logger
            .getLogger(DatabaseCleaner.class.getName());

    private final int iterations;
    private final String[] skipTables;
    private Connection con;
    private List<String> tableNames = new ArrayList<String>();

    public DatabaseCleaner() {
        this(DatabaseSettings.ITERATIONS, DatabaseSettings.SKIP_TABLES);
    }

    public DatabaseCleaner(int iterations, String[] skipTables) {
        this.iterations = iterations;
        this.skipTables = Arrays.copyOf(skipTables, skipTables.length);
    }

    public DatabaseCleaner clear() {
        try {
            establishConnection();

            analyseDatabase();

            boolean entriesLeft = clearDatabase();

            if (entriesLeft) {
                LOGGER.log(Level.WARNING, "The specified amount of {0}"
                        + "iterations was not enough to clear "
                        + "the whole database.", iterations);
            }
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException ex) {
                }
            }
        }

        return this;
    }

    private void establishConnection() {
        try {
            DataSource dataSource = (DataSource) new InitialContext()
                    .lookup("jdbc/odr");
            con = dataSource.getConnection();
        } catch (SQLException ex) {
            throw new DatabaseCleanException("An exception occured while trying to"
                    + "connect to the database.", ex);
        } catch (NamingException ex) {
            throw new DatabaseCleanException("An exception occured while trying to"
                    + "connect to the database.", ex);
        }


    }

    private void analyseDatabase() {
        ResultSet result = null;
        try {
            DatabaseMetaData metaData = con.getMetaData();

            result = metaData.getTables(null, null, "%", new String[]{"TABLE"});

            while (result.next()) {
                String tableName = result.getString("TABLE_NAME");

                if (!shouldBeSkipped(tableName)) {
                    tableNames.add(tableName);
                }
            }
        } catch (SQLException ex) {
            throw new DatabaseCleanException("An exception occured while trying to"
                    + "analyse the database.", ex);
        } finally {
            if (result != null) {
                try {
                    result.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, null, ex);
                }
            }

        }
    }

    private boolean shouldBeSkipped(String name) {
        for (String skipTableName : skipTables) {
            if (skipTableName.equalsIgnoreCase(name)) {
                return true;
            }
        }

        return false;
    }

    private boolean clearDatabase() {
        boolean entriesLeft = true;

        for (int i = 0; i < iterations && entriesLeft; i++) {
            entriesLeft = clearTables();

            if (!entriesLeft) {
                LOGGER.log(Level.INFO, "No database entries left after {0}"
                        + "iteration(s).", i + 1);
            }
        }

        return entriesLeft;
    }

    private boolean clearTables() {
        boolean entriesLeft = false;

        for (String tableName : tableNames) {
            entriesLeft = clearSingleTable(tableName) || entriesLeft;
        }

        return entriesLeft;
    }

    private boolean clearSingleTable(String tableName) {
        ResultSet result = null;
        try {
            boolean entriesLeft = false;

            result = con.createStatement(ResultSet.TYPE_FORWARD_ONLY,
                    ResultSet.CONCUR_UPDATABLE).
                    executeQuery("SELECT * FROM ".concat(tableName));

            while (!result.isClosed() && result.next()) {
                entriesLeft = deleteRow(result) || entriesLeft;
            }


            return entriesLeft;
        } catch (SQLException ex) {
            throw new DatabaseCleanException("Can't read table contents from table "
                    .concat(tableName), ex);
        } finally {
            if (result != null) {
                try {
                    result.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    private boolean deleteRow(ResultSet result) {
        try {
            result.deleteRow();

            return false;
        } catch (SQLException ex) {
            return true;
        }
    }

    public DatabaseCleaner dropAllTables() {
        clear();

        try {
            establishConnection();

            analyseDatabase();

            dropTables();
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException ex) {
                }
            }
        }

        return this;
    }

    private void dropTables() {

        for (int i = 0; i < iterations && !tableNames.isEmpty(); i++) {
            Iterator<String> tableNamesIt = tableNames.iterator();

            while (tableNamesIt.hasNext()) {
                try {
                    con.createStatement().executeUpdate("DROP TABLE "
                            .concat(tableNamesIt.next()));
                    tableNamesIt.remove();
                } catch (SQLException ex) {
                }
            }

        }
    }

    public static void bruteForceCleanup() {
        new DatabaseCleaner().clear();
    }

    public static void main(String[] args) {
        new DatabaseCleaner().clear();
    }
}
{% endhighlight %}