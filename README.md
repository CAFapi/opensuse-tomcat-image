# openSUSE with Java and Tomcat image

This project builds on the openSUSE Java 8 image [here](https://github.com/CAFapi/opensuse-java8-images) to build two pre-configured
Tomcat Docker images that use two logging frameworks.  One of the images uses the Logback logging framework and the other that uses
Tomcat JULI logging.

They can be used as base images for hosting web projects which use Java technologies such as Java Servlets or JavaServer Pages.

Here is an example Dockerfile which uses one of the images as a base:

    FROM cafapi/opensuse-tomcat:latest

    COPY demowebapp/ $CATALINA_HOME/webapps/demowebapp/
    COPY demowebapp-admin/ $CATALINA_HOME/adminapps/ROOT/

The derived image is expected to supply the web application being deployed, which should be copied into Tomcat's default `webapps` directory, and it is also expected to supply an administration application, which should be copied into the `adminapps` directory.  The administration application must supply a `/healthcheck` endpoint which can be used by Docker, or the container orchestrator, to check on the health of the service when it is running.  The administration application may optionally supply other administration or operations functionality, to assist with debugging for example, but it is required to supply a healthcheck endpoint.

### Tini
[Tini](https://github.com/krallin/tini) is pre-installed in the container.  If the image entrypoint is not overwritten then it will be automatically used.

### PostgreSQL Client
[PostgreSQL Client](https://www.postgresql.org/docs/current/static/app-psql.html) is pre-installed in the container. psql is a terminal-based front-end to PostgreSQL. It enables you to type in queries interactively, issue them to PostgreSQL, and see the query results. Alternatively, input can be from a file or from command line arguments. In addition, psql provides a number of meta-commands and various shell-like features to facilitate writing scripts and automating a wide variety of tasks.

### DejaVu Fonts
[DejaVu Fonts](https://dejavu-fonts.github.io/) is pre-installed in the container. The DejaVu fonts are a font family based on the Bitstream Vera Fonts. Its purpose is to provide a wider range of characters while maintaining the original look and feel through the process of collaborative development.

### Gosu
[Gosu](https://github.com/tianon/gosu/) is pre-installed in the container. Gosu allows derived images to run commands as a specified user, rather than as the default user.  

To use gosu, set the `RUNAS_USER` environment variable in the derived container's Dockerfile. Subsequent commands will then be run as the specified user:

```
ENV RUNAS_USER=my-user
CMD ["whoami"] # Outputs my-user
```

Note: the user specified by the `RUNAS_USER` is expected to already exist, and the `CMD` will fail if this is not the case.

### Startup Scripts
Any executable scripts added to the `/startup/startup.d/` directory will be automatically run each time the container is started (assuming the image entrypoint is not overwritten).

### Pre-Installed Startup Scripts

#### Certificate Installation
The image comes pre-installed with a startup script which provides a mechanism to extend the CA certificates which should be trusted.

#### Export File-Based Secrets Script
The image comes pre-installed with a startup script which provides support for file-based secrets.

It works by looking for environment variables ending with the _FILE prefix and setting the environment variable base name to the contents of the file.

For example, given this environment variable ending in the _FILE suffix:
```
ABC_PASSWORD_FILE=/var/somefile.txt
```
the script will read the contents of /var/somefile.txt (for example 'mypassword'), and export an environment variable named ABC_PASSWORD:
```
ABC_PASSWORD=mypassword
```
This feature is disabled by default. To enable it, ensure a `USE_FILE_BASED_SECRETS` environment variable is present, with a value of `true`, for example, `USE_FILE_BASED_SECRETS=true`.

#### Setup Log Level Script
The image comes pre-installed with a script that configures the Tomcat log level with the level set in the provided environment variable `CAF_LOG_LEVEL`. The levels available are mapped to Tomcat log levels as follows:

| **CAF_LOG_LEVEL** | **Tomcat Log Level** |
|:-----------------:|:--------------------:|
|       FATAL       |        SEVERE        |
|       ERROR       |        SEVERE        |
|        WARN       |        WARNING       |
|        INFO       |         INFO         |
|       DEBUG       |         FINE         |
|       TRACE       |        FINEST        |

#### Setup SSL Certificate for Tomcat Script
This image comes pre-installed with a utility script which can be used to setup a SSL certificate for use with Tomcat.

If the `SSL_TOMCAT_CA_CERT_LOCATION` environment variable is present then the script will be executed and the following environment variables are read:

|      **Environment Variable**     | **Required** |                                               **Description**                                              |
|---------------------------------|:------------:|----------------------------------------------------------------------------------------------------------|
| SSL_TOMCAT_CA_CERT_LOCATION       |      Yes     | Location of the SSL certificate to be setup. **Note**: this replaces the location of the default keystore. |
| SSL_TOMCAT_CA_CERT_KEYSTORE_PASS  |      No      | Replaces the default keystore password.                                                                    |
| SSL_TOMCAT_CA_CERT_KEY_PASS       |      No      | Replaces the default key password.                                                                         |
| SSL_TOMCAT_CA_CERT_KEYSTORE_ALIAS |      No      | Replaces the default keystore alias.                                                                       |

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
