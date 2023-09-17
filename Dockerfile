FROM adoptopenjdk/openjdk8

# Add a non-root user and group
RUN addgroup -S pipeline && adduser -S -G pipeline k8s-pipeline

# Set the working directory
WORKDIR /home/k8s-pipeline

# Copy the JAR file
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Set the user to run the application
USER k8s-pipeline

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
