FROM adoptopenjdk/openjdk8
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]