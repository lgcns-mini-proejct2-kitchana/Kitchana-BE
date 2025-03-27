# Build part
FROM gradle:8.12.1-jdk17 AS builder
WORKDIR /app
COPY Config-server/ .
RUN gradle build --no-daemon

# Execute part
FROM amazoncorretto:17
WORKDIR /app
COPY --from=builder /app/build/libs/configserver-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "configserver-0.0.1-SNAPSHOT.jar"]