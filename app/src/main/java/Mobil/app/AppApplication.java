package Mobil.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AppApplication {

	public static void main(String[] args) {
		// Railway DATABASE_URL: postgresql://user:pass@host:port/db
		// Spring Boot needs: jdbc:postgresql://host:port/db?user=user&password=pass
		String dbUrl = System.getenv("DATABASE_URL");
		if (dbUrl != null && dbUrl.startsWith("postgresql://")) {
			// Convert: postgresql://user:pass@host:port/db
			// To:      jdbc:postgresql://host:port/db?user=user&password=pass
			try {
				String withoutScheme = dbUrl.substring("postgresql://".length());
				// withoutScheme = user:pass@host:port/db
				String[] atSplit = withoutScheme.split("@");
				String userInfo = atSplit[0]; // user:pass
				String hostAndDb = atSplit[1]; // host:port/db

				String[] userPass = userInfo.split(":", 2);
				String user = userPass[0];
				String pass = userPass.length > 1 ? userPass[1] : "";

				String jdbcUrl = "jdbc:postgresql://" + hostAndDb + "?user=" + user + "&password=" + pass;
				System.setProperty("spring.datasource.url", jdbcUrl);
				System.out.println("✅ DATABASE_URL converted to JDBC format");
			} catch (Exception e) {
				System.err.println("❌ Failed to parse DATABASE_URL: " + e.getMessage());
			}
		}

		SpringApplication.run(AppApplication.class, args);
	}

}
