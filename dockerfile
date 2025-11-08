# ---------- Stage 1: Build the WAR using Maven ----------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

COPY . .
RUN mvn dependency:go-offline -B

RUN mvn clean package -DskipTests

# ---------- Stage 2: Deploy the WAR to Tomcat ----------
FROM tomcat:10.1-jdk17-temurin


# Copy the WAR file from the build stage
COPY --from=builder /app/target/addressbook.war /usr/local/tomcat/webapps/addressbook.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
