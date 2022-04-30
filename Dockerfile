FROM maven AS build
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn clean package

FROM ubuntu:latest
RUN apt-get -y update && apt-get -y upgrade  && \
    apt-get -y install openjdk-8-jdk wget  && \
    mkdir /usr/local/tomcat
RUN  cd /tmp/;wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz
RUN  cd /tmp/; tar -xvzf apache-tomcat-9.0.62.tar.gz   
 #       mv /tmp/apache-tomcat-9.0.62 /tmp/tomcat && \
 #       cp -R /tmp/apache-tomcat/*  /usr/local/tomcat/
#CMD /usr/local/tomcat/bin/startup.sh run
CMD /tmp/apache-tomcat-9.0.62/bin/startup.sh
#expose port 8080
EXPOSE 8080
#default command
#CMD java -jar /data/hello-world-0.1.0.jar 
#copy hello world to docker image from builder image
#COPY --from=maven_build /tmp/target/hello-world-0.1.0.jar /data/hello-world-0.1.0.jar
COPY --from=build /tmp/target/*.jar /tmp/apache-tomcat-9.0.62/webapps
