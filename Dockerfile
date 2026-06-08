# fase 1
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests

# fase 2
FROM tomcat:9.0-jdk21-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/target/WaveNotes.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080