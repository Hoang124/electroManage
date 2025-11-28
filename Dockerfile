# Stage 1: Build ứng dụng bằng Maven
FROM maven:3.9.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy file cấu hình Maven trước để cache dependency
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Tạo image chạy app
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Copy file JAR từ stage build sang stage run
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
