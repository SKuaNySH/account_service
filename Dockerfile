FROM eclipse-temurin:17-jdk
WORKDIR /app

COPY /build/libs/service.jar app.jar

WORKDIR /app/build
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

