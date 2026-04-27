package Mobil.app.config;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        System.out.println("=== DATABASE CONFIGURATION DEBUG ===");
        
        // TEMPORARY: Hardcoded public endpoint for testing
        // TODO: Move to environment variables after testing
        String hardcodedHost = "shuttle.proxy.rlwy.net";
        String hardcodedPort = "49209";
        String hardcodedDatabase = "railway";
        String hardcodedUser = "postgres";
        String hardcodedPassword = "JzIipoNHxedlTeuWHrhQyKIMBzftbpju"; // TEMPORARY - will remove after testing
        
        String jdbcUrl = String.format(
            "jdbc:postgresql://%s:%s/%s",
            hardcodedHost,
            hardcodedPort,
            hardcodedDatabase
        );
        
        System.out.println("✅ Using HARDCODED public endpoint (temporary for testing)");
        System.out.println("   JDBC URL: " + jdbcUrl);
        System.out.println("   User: " + hardcodedUser);
        
        return DataSourceBuilder
                .create()
                .url(jdbcUrl)
                .username(hardcodedUser)
                .password(hardcodedPassword)
                .driverClassName("org.postgresql.Driver")
                .build();
    }
}
