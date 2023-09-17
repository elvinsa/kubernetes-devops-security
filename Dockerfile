FROM adoptopenjdk/openjdk8

# Set a non-root user
RUN useradd -u 100 -m -s /bin/bash k8s-pipeline && \
    groupadd -g 100 pipeline && \
    usermod -a -G pipeline k8s-pipeline

# Set the working directory
WORKDIR /home/k8s-pipeline

# Expose the port
EXPOSE 8080

# Copy the JAR file
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar

# Set the user to run the application
USER k8s-pipeline

# Command to run the application
ENTRYPOINT ["java", "-jar", "/home/k8s-pipeline/app.jar"]
