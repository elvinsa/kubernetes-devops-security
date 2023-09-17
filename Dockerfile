FROM adoptopenjdk/openjdk8
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN adduser k8s-pipeline --home /home/k8s-pipeline --shell --uid 100 && addgroup --gid 100 pipeline && adduser --group --gid 100 pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]