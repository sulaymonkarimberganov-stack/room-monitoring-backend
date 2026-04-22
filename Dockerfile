FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY app/mvnw .
COPY app/.mvn .mvn
COPY app/pom.xml .
COPY app/src src
RUN chmod +x mvnw
RUN ./mvnw package -DskipTests

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
