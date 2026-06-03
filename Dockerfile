FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Copy Maven files
COPY app/.mvn/ .mvn/
COPY app/mvnw app/pom.xml ./
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Copy source code
COPY app/src ./src
RUN ./mvnw package -DskipTests -B

FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
