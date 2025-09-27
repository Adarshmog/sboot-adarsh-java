# Step 1: Use Maven with JDK 8 to build
FROM maven:3.6.3-jdk-8 AS build

WORKDIR /app

# Copy source code
COPY . .

# Build the project (creates WAR inside target/)
RUN mvn clean package -DskipTests

# Step 2: Run the Spring Boot WAR with JDK 8
FROM openjdk:8-jdk-alpine

WORKDIR /app

# Copy WAR from build stage
COPY --from=build /app/target/spring-boot-rest-example-0.5.0.war app.war

# Expose application ports
EXPOSE 8090 8091

# Run with "test" profile (H2 in-memory DB)
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=test", "app.war"]

