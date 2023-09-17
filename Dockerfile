FROM adoptopenjdk/openjdk8
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -g 1000 pipeline && adduser -D -u 1000 -G pipeline k8s-pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]
