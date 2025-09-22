FROM openjdk:17-jdk-slim
WORKDIR /app
COPY . /app
RUN ./mvnw package
CMD ["java", "-cp", "target/myapp-1.0-SNAPSHOT.jar", "App"]
