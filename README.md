# openSUSE with Java and Tomcat image

This project builds on the openSUSE Java image [here](https://github.com/CAFapi/opensuse-jre8-image) to build a pre-configured Tomcat Docker image.

It can be used as a base image for hosting web projects which use Java technologies such as Java Servlets or JavaServer Pages.

Here is an example Dockerfile which uses this image as a base:

    FROM cafapi/opensuse-tomcat:latest

    COPY demowebapp/ $CATALINA_HOME/webapps/demowebapp/
    COPY demowebapp-admin/ $CATALINA_HOME/adminapps/ROOT/

The derived image is expected to supply the web application being deployed, which should be copied into Tomcat's default `webapps` directory, and it is also expected to supply an administration application, which should be copied into the `adminapps` directory.  The administration application must supply a `/healthcheck` endpoint which can be used by Docker, or the container orchestrator, to check on the health of the service when it is running.  The administration application may optionally supply other administration or operations functionality, to assist with debugging for example, but it is required to supply a healthcheck endpoint.

### Tini
[Tini](https://github.com/krallin/tini) is pre-installed in the container.  If the image entrypoint is not overwritten then it will be automatically used.

### PostgreSQL Client
[PostgreSQL Client](https://www.postgresql.org/docs/current/static/app-psql.html) is pre-installed in the container. psql is a terminal-based front-end to PostgreSQL. It enables you to type in queries interactively, issue them to PostgreSQL, and see the query results. Alternatively, input can be from a file or from command line arguments. In addition, psql provides a number of meta-commands and various shell-like features to facilitate writing scripts and automating a wide variety of tasks.

### Startup Scripts
Any executable scripts added to the `/startup/startup.d/` directory will be automatically run each time the container is started (assuming the image entrypoint is not overwritten).

### Pre-Installed Startup Scripts

#### Certificate Installation
The image comes pre-installed with a startup script which provides a mechanism to extend the CA certificates which should be trusted.

### Pre-Installed Utility Scripts

#### Database Creation Script
The image comes pre-installed with a utility script which can be used to check if a PostgreSQL database exists and to create it if it does not.

When the script is called it must be passed an environment variable prefix for the service:

    /scripts/check-create-pgdb.sh SERVICE_

The script then reads the database details from a set of environment variables with the specified prefix:

| **Environment Variable**    |                                          **Description**                                               |
|-----------------------------|--------------------------------------------------------------------------------------------------------|
| `SERVICE_`DATABASE_HOST     | The host name of the machine on which the PostgreSQL server is running.                                |
| `SERVICE_`DATABASE_PORT     | The TCP port on which the PostgreSQL server is listening for connections.                              |
| `SERVICE_`DATABASE_USERNAME | The username to use when establishing the connection to the PostgreSQL server.                         |
| `SERVICE_`DATABASE_PASSWORD | The password to use when establishing the connection to the PostgreSQL server.                         |
| `SERVICE_`DATABASE_APPNAME  | The application name that PostgreSQL should associate with the connection for logging and monitoring.  |
| `SERVICE_`DATABASE_NAME     | The name of the PostgreSQL database to be created.                                                     |

#### Setup Log Level Script
The image comes pre-installed with a script `setup-loglevel.sh` that will set the Tomcat log level in `$CATALINA_HOME/conf/logging.properties` with the value in the provided environment variable `CAF_LOG_LEVEL`. The levels available are mapped to Tomcat log levels as follows:

| *CAF_LOG_LEVEL* | *Tomcat Log Level* |
|:---------------:|:------------------:|
|      FATAL      | SEVERE             |
|      ERROR      | SEVERE             |
|       WARN      | WARNING            |
|      DEBUG      | FINE               |
|      TRACE      | FINEST             |