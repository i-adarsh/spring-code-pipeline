FROM maven:3.9.5 AS build
WORKDIR /app
ARG CONTAINER_PORT
COPY pom.xml /app
RUN mvn dependency:resolve
COPY . /app
RUN mvn clean
RUN mvn package -DskipTests -X

FROM public.ecr.aws/g6s0o6c5/openjdk17.0.1:latest
COPY --from=build /app/target/*.jar app.jar
EXPOSE ${CONTAINER_PORT}
CMD ["java", "-jar", "app.jar"]