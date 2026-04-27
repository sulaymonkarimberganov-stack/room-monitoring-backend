package Mobil.app;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        String databaseUrl = System.getenv("DATABASE_URL");
        
        // Try to use Railway's DATABASE_URL if available
        if (databaseUrl != null && !databaseUrl.isEmpty()) {
            try {
                // Railway format: postgresql://user:password@host:port/database
                // Convert to JDBC format: jdbc:postgresql://host:port/database
                String jdbcUrl = databaseUrl.replace("postgresql://", "jdbc:postgresql://");
                
                // Add SSL mode if not already present
                if (!jdbcUrl.contains("sslmode=")) {
                    jdbcUrl += (jdbcUrl.contains("?") ? "&" : "?") + "sslmode=require";
                }
                
                return DataSourceBuilder
                        .create()
                        .url(jdbcUrl)
                        .driverClassName("org.postgresql.Driver")
                        .build();
            } catch (Exception e) {
                System.err.println("Failed to parse DATABASE_URL: " + e.getMessage());
                // Fall through to individual variables
            }
        }
        
        // Try Railway's individual environment variables
        String pgHost = System.getenv("PGHOST");
        String pgPort = System.getenv("PGPORT");
        String pgDatabase = System.getenv("PGDATABASE");
        String pgUser = System.getenv("PGUSER");
        String pgPassword = System.getenv("PGPASSWORD");
        
        if (pgHost != null && pgDatabase != null) {
            String jdbcUrl = String.format(
                "jdbc:postgresql://%s:%s/%s?sslmode=require",
                pgHost,
                pgPort != null ? pgPort : "5432",
                pgDatabase
            );
            
            return DataSourceBuilder
                    .create()
                    .url(jdbcUrl)
                    .username(pgUser != null ? pgUser : "postgres")
                    .password(pgPassword != null ? pgPassword : "postgres")
                    .driverClassName("org.postgresql.Driver")
                    .build();
        }
        
        // Fallback to default configuration for local development
        return DataSourceBuilder
                .create()
                .url("jdbc:postgresql://localhost:5432/room_monitoring")
                .username("postgres")
                .password("postgres")
                .driverClassName("org.postgresql.Driver")
                .build();
    }
}
