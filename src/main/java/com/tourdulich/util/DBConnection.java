package com.tourdulich.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);
    private static HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader()
                    .getResourceAsStream("db.properties");
            
            if (is == null) {
                throw new RuntimeException("Không tìm thấy file db.properties");
            }
            
            props.load(is);
            
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));
            config.setDriverClassName(props.getProperty("db.driver"));
            
            config.setMaximumPoolSize(
                Integer.parseInt(props.getProperty("db.pool.maximumPoolSize", "10"))
            );
            config.setMinimumIdle(
                Integer.parseInt(props.getProperty("db.pool.minimumIdle", "5"))
            );
            config.setConnectionTimeout(
                Long.parseLong(props.getProperty("db.pool.connectionTimeout", "30000"))
            );
            config.setIdleTimeout(
                Long.parseLong(props.getProperty("db.pool.idleTimeout", "600000"))
            );
            config.setMaxLifetime(
                Long.parseLong(props.getProperty("db.pool.maxLifetime", "1800000"))
            );
            
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            config.addDataSourceProperty("useServerPrepStmts", "true");
            
            dataSource = new HikariDataSource(config);
            logger.info("Khởi tạo connection pool thành công");
            
        } catch (Exception e) {
            logger.error("Lỗi khởi tạo connection pool", e);
            throw new RuntimeException("Không thể khởi tạo database connection pool", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                logger.error("Lỗi đóng connection", e);
            }
        }
    }

    public static void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            logger.info("Đóng connection pool");
        }
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            logger.error("Test connection thất bại", e);
            return false;
        }
    }
}

