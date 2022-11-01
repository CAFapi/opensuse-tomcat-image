#
# Copyright 2017-2022 Micro Focus or one of its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Docker registry
ARG DOCKER_HUB_PUBLIC=docker.io

#
# Preliminary image that downloads Tomcat and makes some modifications
#
FROM ${DOCKER_HUB_PUBLIC}/opensuse/leap:latest AS builder
RUN zypper -n install gzip tar xsltproc
WORKDIR /wd

ENV TOMCAT_PARENT_DIR=/wd/root/usr/share \
    TOMCAT_DIR_NAME=tomcat
ENV TOMCAT_ROOT_DIR $TOMCAT_PARENT_DIR/$TOMCAT_DIR_NAME
ENV TOMCAT_CONF_DIR $TOMCAT_ROOT_DIR/conf
ENV TOMCAT_BIN_DIR $TOMCAT_ROOT_DIR/bin
ENV TOMCAT_LIB_DIR $TOMCAT_ROOT_DIR/lib

# Extract Tomcat and remove unwanted web applications
COPY apache-tomcat-9.0.64.tar.gz .
RUN mkdir -p $TOMCAT_PARENT_DIR && \
    cd $TOMCAT_PARENT_DIR && \
    tar xzf /wd/apache-tomcat-9.0.64.tar.gz && \
    mv apache-tomcat-9.0.64 $TOMCAT_DIR_NAME && \
    cd $TOMCAT_ROOT_DIR/webapps && \
    rm -rf $TOMCAT_CONF_DIR/logging.properties docs/ examples/ host-manager/ manager/ ROOT/

# Copy new logback.xml and logback-access.xml to tomcat conf folder for logback implementation
COPY logback*.xml $TOMCAT_CONF_DIR/

# Copy new setenv.bat and setenv.sh to tomcat bin folder
COPY setenv.* $TOMCAT_BIN_DIR/

# Copy a new lib folder with thirdparty jars for logback implementation to tomcat lib folder
COPY /maven/lib/*.jar $TOMCAT_LIB_DIR/
RUN mv $TOMCAT_LIB_DIR/caf-logging-tomcat-juli-*.jar  $TOMCAT_BIN_DIR/tomcat-juli.jar

# Apply the specified transform to the server.xml file
COPY server.xslt .
RUN cp $TOMCAT_CONF_DIR/server.xml .
RUN xsltproc -o $TOMCAT_CONF_DIR/server.xml server.xslt server.xml

# Add in the startup scripts
COPY startup.d/ root/startup/startup.d/
RUN chmod +x root/startup/startup.d/*


###
# Security enhanced web.xml
###
COPY web.xml ${CATALINA_HOME}/conf/

#
# The actual image definition
#
FROM ${DOCKER_HUB_PUBLIC}/cafapi/opensuse-jre8:3

RUN zypper -n refresh && \
    zypper -n update && \
    zypper -n clean --all

ENV CATALINA_HOME /usr/share/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

ARG USER_ID=${TOMCAT_USER_ID:-1000}
ARG GROUP_ID=${TOMCAT_GROUP_ID:-1000}


###
# Tomcat user and group created
###
RUN    groupadd -r tomcat -g ${GROUP_ID}
RUN    useradd -u ${USER_ID} -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin \
        -c "Tomcat user" tomcat

###
# Change CATALINA_HOME ownership to tomcat user and tomcat group
###

RUN   chown -R tomcat:tomcat ${CATALINA_HOME}

HEALTHCHECK CMD curl --fail http://localhost:8081/healthcheck || exit 1

###
# Start container
# Container started as non-root user for security purposes
###

USER tomcat

EXPOSE 8080 8081 8443
CMD ["catalina.sh", "run"]

COPY --from=builder /wd/root/ /
