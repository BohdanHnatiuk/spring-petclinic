FROM java:8
VOLUME /tmp
ADD target/spring-petclinic-2.4.5.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
#CMD ["java","-jar","/app.jar"]
