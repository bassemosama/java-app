FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY target/myapp-1.0-SNAPSHOT.jar app.jar
CMD ["java", "-jar", "app.jar"]
