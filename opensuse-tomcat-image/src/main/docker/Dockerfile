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

#OpenSUSE Tomcat Base image
ARG JULI_IMAGE
FROM $JULI_IMAGE AS builder
RUN zypper -n install xsltproc
ENV CATALINA_HOME /usr/share/tomcat

ENV CATALINA_CONF_DIR $CATALINA_HOME/conf
ENV CATALINA_BIN_DIR $CATALINA_HOME/bin
ENV CATALINA_LIB_DIR $CATALINA_HOME/lib

ENV PATH $CATALINA_BIN_DIR:$PATH

WORKDIR $CATALINA_HOME

RUN rm -rf $CATALINA_CONF_DIR/logging.properties

# Copy new logback.xml and logback-access.xml to tomcat conf folder for logback implementation
COPY logback*.xml $CATALINA_CONF_DIR/

# Copy new setenv.bat and setenv.sh to tomcat bin folder
COPY setenv.* $CATALINA_BIN_DIR/

# Copy a new lib folder with thirdparty jars for logback implementation to tomcat lib folder
COPY /maven/lib/*.jar $CATALINA_LIB_DIR/
RUN mv lib/caf-logging-tomcat-juli-*.jar bin/tomcat-juli.jar

# Apply the specified transform to the server.xml file
COPY server.xslt .
RUN xsltproc -o $CATALINA_CONF_DIR/server.xml server.xslt $CATALINA_CONF_DIR/server.xml

ENV WDBUILDER = /wd/root

RUN mkdir -p $WDBUILDER/tomcat && \
    cp -R /startup/startup.d $WDBUILDER && \
    cp -R $CATALINA_HOME $WDBUILDER/tomcat

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

HEALTHCHECK CMD curl --fail http://localhost:8081/healthcheck || exit 1

EXPOSE 8080 8081 8443
CMD ["catalina.sh", "run"]

COPY --from=builder $WDBUILDER /
