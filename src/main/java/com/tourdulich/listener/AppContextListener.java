package com.tourdulich.listener;

import com.tourdulich.util.DBConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {
    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("========================================");
        logger.info("Tour Du Lich Application đang khởi động...");
        logger.info("========================================");
        

        try {
            boolean connected = DBConnection.testConnection();
            if (connected) {
                logger.info("✓ Kết nối database thành công");
            } else {
                logger.error("✗ Không thể kết nối database");
            }
        } catch (Exception e) {
            logger.error("✗ Lỗi khởi tạo database", e);
        }
        
        logger.info("Application khởi động hoàn tất");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("========================================");
        logger.info("Tour Du Lich Application đang dừng...");
        logger.info("========================================");
        

        DBConnection.closePool();
        
        logger.info("Application dừng hoàn tất");
    }
}

