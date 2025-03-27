# Build part
FROM gradle:8.12.1-jdk17 AS builder
WORKDIR /app
COPY eureka/ .
RUN gradle build --no-daemon

# Execute part
FROM amazoncorretto:17
WORKDIR /app
COPY --from=builder /app/build/libs/eureka-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "eureka-0.0.1-SNAPSHOT.jar"]
