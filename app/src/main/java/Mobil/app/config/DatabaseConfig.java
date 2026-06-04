package Mobil.app.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;

@Configuration
public class DatabaseConfig {

    @Bean
    @Primary
    public DataSource dataSource() throws URISyntaxException {
        String dbUrl = System.getenv("DATABASE_URL");

        HikariConfig config = new HikariConfig();
        config.setMaximumPoolSize(5);
        config.setConnectionTimeout(30000);

        if (dbUrl != null && !dbUrl.isEmpty() &&
                (dbUrl.startsWith("postgresql://") || dbUrl.startsWith("postgres://"))) {

            // Parse Railway DATABASE_URL: postgresql://user:pass@host:port/db
            URI uri = new URI(dbUrl.replace("postgres://", "postgresql://"));

            String host = uri.getHost();
            int port = uri.getPort() == -1 ? 5432 : uri.getPort();
            String db = uri.getPath().replaceFirst("/", "");
            String[] userInfo = uri.getUserInfo().split(":", 2);
            String user = userInfo[0];
            String pass = userInfo.length > 1 ? userInfo[1] : "";

            String jdbcUrl = String.format(
                "jdbc:postgresql://%s:%d/%s?sslmode=require", host, port, db);

            config.setJdbcUrl(jdbcUrl);
            config.setUsername(user);
            config.setPassword(pass);
            config.setDriverClassName("org.postgresql.Driver");

            System.out.println("✅ DB connected: " + host + ":" + port + "/" + db + " user=" + user);

        } else if (dbUrl != null && dbUrl.startsWith("jdbc:")) {
            // Already JDBC format
            config.setJdbcUrl(dbUrl);
            config.setDriverClassName("org.postgresql.Driver");
            System.out.println("✅ DB connected (JDBC format)");

        } else {
            // Local fallback
            config.setJdbcUrl("jdbc:postgresql://localhost:5432/railway");
            config.setUsername("postgres");
            config.setPassword("");
            config.setDriverClassName("org.postgresql.Driver");
            System.out.println("⚠️ Using localhost DB (DATABASE_URL not set)");
        }

        return new HikariDataSource(config);
    }
}
