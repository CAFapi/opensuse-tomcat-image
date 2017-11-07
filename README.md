# openSUSE with Java and Tomcat image

This project builds on the openSUSE Java image [here](https://github.com/CAFapi/opensuse-jre8-image) to build a pre-configured Tomcat Docker image.

It can be used as a base image for hosting web projects which use Java technologies such as Java Servlets or JavaServer Pages.

Here is an example Dockerfile which uses this image as a base:

    FROM cafapi/opensuse-tomcat:latest

    COPY demowebapp/ $CATALINA_HOME/webapps/demowebapp/
    COPY demowebapp-admin/ $CATALINA_HOME/adminapps/ROOT/

The derived image is expected to supply the web application being deployed, which should be copied into Tomcat's default `webapps` directory, and it is also expected to supply an administration application, which should be copied into the `adminapps` directory.  The administration application must supply a `/healthcheck` endpoint which can be used by Docker, or the container orchestrator, to check on the health of the service when it is running.  The administration application may optionally supply other administration or operations functionality, to assist with debugging for example, but it is required to supply a healthcheck endpoint.
