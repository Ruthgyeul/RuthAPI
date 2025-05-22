FROM gradle:8.13.0-jdk21 AS build
WORKDIR /app/RuthAPI

COPY . .
RUN ls -l
RUN chmod +x gradlew
RUN ./gradlew build -x test

RUN cp $(ls /app/RuthAPI/build/libs/*.jar | head -n 1) /app/RuthAPI/build/libs/app.jar

FROM openjdk:21-jdk-slim
WORKDIR /app

COPY --from=build /app/RuthAPI/build/libs/app.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
