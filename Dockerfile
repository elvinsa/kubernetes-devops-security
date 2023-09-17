# Build Stage
FROM adoptopenjdk/openjdk8 AS builder
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /app.jar

# Final Stage
FROM adoptopenjdk/openjdk8
EXPOSE 8080
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
COPY --from=builder /app.jar /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]
