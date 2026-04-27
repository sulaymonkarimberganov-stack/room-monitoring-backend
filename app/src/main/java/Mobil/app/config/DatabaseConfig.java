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
        
        // Log all database-related environment variables
        String databaseUrl = System.getenv("DATABASE_URL");
        String publicUrl = System.getenv("DATABASE_PUBLIC_URL");
        String pgHost = System.getenv("PGHOST");
        String pgPort = System.getenv("PGPORT");
        String pgDatabase = System.getenv("PGDATABASE");
        String pgUser = System.getenv("PGUSER");
        
        System.out.println("DATABASE_URL: " + (databaseUrl != null ? "EXISTS (length: " + databaseUrl.length() + ")" : "NULL"));
        System.out.println("DATABASE_PUBLIC_URL: " + (publicUrl != null ? "EXISTS (length: " + publicUrl.length() + ")" : "NULL"));
        System.out.println("PGHOST: " + (pgHost != null ? pgHost : "NULL"));
        System.out.println("PGPORT: " + (pgPort != null ? pgPort : "NULL"));
        System.out.println("PGDATABASE: " + (pgDatabase != null ? pgDatabase : "NULL"));
        System.out.println("PGUSER: " + (pgUser != null ? pgUser : "NULL"));
        
        // Try DATABASE_PUBLIC_URL first (Railway's public endpoint)
        if (publicUrl != null && !publicUrl.isEmpty()) {
            // Convert postgresql:// to jdbc:postgresql://
            String jdbcUrl = publicUrl.startsWith("jdbc:") ? publicUrl : "jdbc:" + publicUrl;
            
            System.out.println("✅ Using DATABASE_PUBLIC_URL");
            System.out.println("   URL: " + jdbcUrl.replaceAll(":[^:@]+@", ":****@"));
            
            return DataSourceBuilder
                    .create()
                    .url(jdbcUrl)
                    .driverClassName("org.postgresql.Driver")
                    .build();
        }
        
        // Fallback to individual environment variables
        String pgHost = System.getenv("PGHOST");
        String pgPort = System.getenv("PGPORT");
        String pgDatabase = System.getenv("PGDATABASE");
        String pgUser = System.getenv("PGUSER");
        String pgPassword = System.getenv("PGPASSWORD");
        
        if (pgHost != null && pgDatabase != null) {
            String jdbcUrl = String.format(
                "jdbc:postgresql://%s:%s/%s",
                pgHost,
                pgPort != null ? pgPort : "5432",
                pgDatabase
            );
            
            System.out.println("✅ Using individual PG environment variables");
            System.out.println("   Host: " + pgHost);
            
            return DataSourceBuilder
                    .create()
                    .url(jdbcUrl)
                    .username(pgUser != null ? pgUser : "postgres")
                    .password(pgPassword != null ? pgPassword : "postgres")
                    .driverClassName("org.postgresql.Driver")
                    .build();
        }
        
        // Local development fallback
        System.out.println("⚠️  Using local development database");
        return DataSourceBuilder
                .create()
                .url("jdbc:postgresql://localhost:5432/room_monitoring")
                .username("postgres")
                .password("postgres")
                .driverClassName("org.postgresql.Driver")
                .build();
    }
}
