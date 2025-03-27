# Build part
FROM gradle:8.12.1-jdk17 AS builder
WORKDIR /app
COPY API-Gateway/ .
RUN gradle build -x test --no-daemon

# Execute part
FROM amazoncorretto:17
WORKDIR /app
COPY --from=builder /app/build/libs/gateway-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "gateway-0.0.1-SNAPSHOT.jar"]