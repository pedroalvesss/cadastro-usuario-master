FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /workspace

COPY pom.xml ./
COPY src ./src

RUN mvn -B -DskipTests package

FROM eclipse-temurin:21-jre

ARG JAR_FILE=/workspace/target/cadastro-usuario-0.0.1-SNAPSHOT.jar
COPY --from=build ${JAR_FILE} /app/app.jar
WORKDIR /app

EXPOSE 8081

RUN addgroup --system app && adduser --system --ingroup app appuser \
    && chown -R appuser:app /app
USER appuser

ENTRYPOINT ["java","-jar","/app/app.jar"]
