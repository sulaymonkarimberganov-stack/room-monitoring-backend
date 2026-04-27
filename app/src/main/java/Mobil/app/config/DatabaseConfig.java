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
        String hardcodedPassword = System.getenv("PGPASSWORD"); // Still use env for password
        
        if (hardcodedPassword != null && !hardcodedPassword.isEmpty()) {
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
        
        // Try custom DB_ variables first (manually configured public endpoint)
        String dbHost = System.getenv("DB_HOST");
        String dbPort = System.getenv("DB_PORT");
        String dbName = System.getenv("DB_NAME");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");
        
        System.out.println("DB_HOST: " + (dbHost != null ? dbHost : "NULL"));
        System.out.println("DB_PORT: " + (dbPort != null ? dbPort : "NULL"));
        System.out.println("DB_NAME: " + (dbName != null ? dbName : "NULL"));
        System.out.println("DB_USER: " + (dbUser != null ? dbUser : "NULL"));
        System.out.println("DB_PASSWORD: " + (dbPassword != null ? "EXISTS" : "NULL"));
        
        if (dbHost != null && dbName != null && dbUser != null && dbPassword != null) {
            String jdbcUrl = String.format(
                "jdbc:postgresql://%s:%s/%s",
                dbHost,
                dbPort != null ? dbPort : "5432",
                dbName
            );
            
            System.out.println("✅ Using custom DB_ environment variables (public endpoint)");
            System.out.println("   JDBC URL: " + jdbcUrl);
            
            return DataSourceBuilder
                    .create()
                    .url(jdbcUrl)
                    .username(dbUser)
                    .password(dbPassword)
                    .driverClassName("org.postgresql.Driver")
                    .build();
        }
        
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
        
        // Try DATABASE_URL (convert internal to work with JDBC)
        if (databaseUrl != null && !databaseUrl.isEmpty()) {
            try {
                // Convert postgresql:// to jdbc:postgresql://
                String jdbcUrl = databaseUrl.startsWith("jdbc:") ? databaseUrl : "jdbc:" + databaseUrl;
                
                // Replace internal hostname with proxy if needed
                if (jdbcUrl.contains(".railway.internal")) {
                    System.out.println("⚠️  DATABASE_URL contains internal hostname, this may not work");
                    System.out.println("   Consider using DATABASE_PUBLIC_URL or external connection details");
                }
                
                System.out.println("✅ Using DATABASE_URL");
                System.out.println("   URL: " + jdbcUrl.replaceAll(":[^:@]+@", ":****@"));
                
                return DataSourceBuilder
                        .create()
                        .url(jdbcUrl)
                        .driverClassName("org.postgresql.Driver")
                        .build();
            } catch (Exception e) {
                System.err.println("❌ Failed to use DATABASE_URL: " + e.getMessage());
            }
        }
        
        // Fallback to individual environment variables
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
                    .password(hardcodedPassword != null ? hardcodedPassword : "postgres")
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
