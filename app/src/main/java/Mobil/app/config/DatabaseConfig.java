package Mobil.app.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;

@Configuration
public class DatabaseConfig {

    @Bean
    @Primary
    public DataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setMaximumPoolSize(5);
        config.setConnectionTimeout(30000);
        config.setDriverClassName("org.postgresql.Driver");

        // 1. PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD (Railway standard vars)
        String pgHost = System.getenv("PGHOST");
        String pgPort = System.getenv("PGPORT");
        String pgDb   = System.getenv("PGDATABASE");
        String pgUser = System.getenv("PGUSER");
        String pgPass = System.getenv("PGPASSWORD");

        if (pgHost != null && pgUser != null && pgPass != null) {
            String port = (pgPort != null) ? pgPort : "5432";
            String db   = (pgDb != null)   ? pgDb   : "railway";
            String jdbcUrl = "jdbc:postgresql://" + pgHost + ":" + port + "/" + db + "?sslmode=require";

            config.setJdbcUrl(jdbcUrl);
            config.setUsername(pgUser);
            config.setPassword(pgPass);

            System.out.println("✅ DB via PG vars: " + pgHost + ":" + port + "/" + db + " user=" + pgUser);
            return new HikariDataSource(config);
        }

        // 2. Fallback - localhost
        System.out.println("⚠️ PG vars not found, using localhost");
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/railway");
        config.setUsername("postgres");
        config.setPassword("");
        return new HikariDataSource(config);
    }
}
