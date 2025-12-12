package com.tourdulich.server;

import org.apache.catalina.Context;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;

public class TomcatEmbeddedServer {
    private static final Logger logger = LoggerFactory.getLogger(TomcatEmbeddedServer.class);
    private static final int PORT = 8080;
    private static final String CONTEXT_PATH = "/tour-booking";
    private static final String WEBAPP_DIR = "src/main/webapp";

    public static void main(String[] args) {
        try {
            Tomcat tomcat = new Tomcat();
            tomcat.setPort(PORT);
            tomcat.setHostname("localhost");
            tomcat.getConnector().setURIEncoding("UTF-8");


            String baseDir = System.getProperty("user.dir");
            File webappDir = new File(baseDir, WEBAPP_DIR);
            
            if (!webappDir.exists()) {
                logger.error("Không tìm thấy thư mục webapp: {}", webappDir.getAbsolutePath());
                System.exit(1);
            }


            Context ctx = tomcat.addWebapp(CONTEXT_PATH, webappDir.getAbsolutePath());
            

            File additionWebInfClasses = new File(baseDir, "target/classes");
            if (additionWebInfClasses.exists()) {
                StandardRoot resources = new StandardRoot(ctx);
                resources.addPreResources(
                    new DirResourceSet(resources, "/WEB-INF/classes", 
                        additionWebInfClasses.getAbsolutePath(), "/")
                );
                ctx.setResources(resources);
            }


            ctx.setReloadable(true);

            logger.info("========================================");
            logger.info("  TOUR BOOKING - TOMCAT 9 EMBEDDED");
            logger.info("========================================");
            logger.info("Port: {}", PORT);
            logger.info("Context Path: {}", CONTEXT_PATH);
            logger.info("Webapp Directory: {}", webappDir.getAbsolutePath());
            logger.info("========================================");
            logger.info("Server đang khởi động...");
            logger.info("Truy cập: http://localhost:" + PORT + CONTEXT_PATH);
            logger.info("Nhấn Ctrl+C để dừng server");
            logger.info("========================================");


            tomcat.start();
            tomcat.getServer().await();

        } catch (LifecycleException e) {
            logger.error("Lỗi khởi động Tomcat", e);
            System.exit(1);
        } catch (Exception e) {
            logger.error("Lỗi không xác định", e);
            System.exit(1);
        }
    }
}

