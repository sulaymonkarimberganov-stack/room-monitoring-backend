package Mobil.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AppApplication {

	public static void main(String[] args) {
		// Railway provides DATABASE_URL as: postgresql://user:pass@host:port/db
		// Spring Boot needs JDBC format: jdbc:postgresql://host:port/db?user=user&password=pass
		String dbUrl = System.getenv("DATABASE_URL");
		if (dbUrl != null && !dbUrl.isEmpty()) {
			String jdbcUrl;
			if (dbUrl.startsWith("jdbc:")) {
				// Already in JDBC format
				jdbcUrl = dbUrl;
			} else if (dbUrl.startsWith("postgresql://") || dbUrl.startsWith("postgres://")) {
				// Convert Railway format to JDBC format
				try {
					// postgresql://user:pass@host:port/db
					String stripped = dbUrl.replaceFirst("^postgres(ql)?://", "");
					// stripped = user:pass@host:port/db
					int atIndex = stripped.lastIndexOf('@');
					String userInfo = stripped.substring(0, atIndex);   // user:pass
					String hostPart = stripped.substring(atIndex + 1);  // host:port/db

					String user = userInfo.contains(":") ? userInfo.split(":", 2)[0] : userInfo;
					String pass = userInfo.contains(":") ? userInfo.split(":", 2)[1] : "";

					jdbcUrl = "jdbc:postgresql://" + hostPart + "?user=" + user + "&password=" + pass + "&sslmode=require";
					System.out.println("✅ DATABASE_URL converted to JDBC: jdbc:postgresql://" + hostPart + "?user=" + user + "&password=***");
				} catch (Exception e) {
					System.err.println("❌ Failed to parse DATABASE_URL: " + e.getMessage());
					jdbcUrl = null;
				}
			} else {
				jdbcUrl = null;
				System.err.println("❌ Unknown DATABASE_URL format: " + dbUrl.substring(0, Math.min(20, dbUrl.length())));
			}

			if (jdbcUrl != null) {
				System.setProperty("spring.datasource.url", jdbcUrl);
			}
		} else {
			System.out.println("⚠️ DATABASE_URL not set, using default localhost");
		}

		SpringApplication.run(AppApplication.class, args);
	}
}
