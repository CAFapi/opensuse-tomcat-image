#
# Copyright 2017-2024 Open Text.
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
# Preliminary image, makes some modifications to the JULI image
#
ARG JULI_IMAGE
FROM $JULI_IMAGE AS builder

RUN zypper -n install xsltproc

ENV CATALINA_HOME /usr/share/tomcat
ENV CATALINA_CONF_DIR $CATALINA_HOME/conf
ENV CATALINA_BIN_DIR $CATALINA_HOME/bin
ENV CATALINA_LIB_DIR $CATALINA_HOME/lib

ENV PATH $CATALINA_BIN_DIR:$PATH

WORKDIR $CATALINA_HOME

RUN rm -rf $CATALINA_CONF_DIR/logging.properties \
           /startup/startup.d/setup-loglevel.sh

# Copy new logback.xml and logback-access.xml to tomcat conf folder for logback implementation
COPY logback*.xml $CATALINA_CONF_DIR/

# Copy new setenv.bat and setenv.sh to tomcat bin folder
COPY setenv.* $CATALINA_BIN_DIR/

# Copy a new lib folder with thirdparty jars for logback implementation to tomcat lib folder
COPY /maven/lib/*.jar $CATALINA_LIB_DIR/
RUN mv $CATALINA_LIB_DIR/caf-logging-tomcat-juli-*.jar $CATALINA_BIN_DIR/tomcat-juli.jar

# Apply the specified transform to the server.xml file
COPY server.xslt .
RUN xsltproc -o $CATALINA_CONF_DIR/server.xml server.xslt $CATALINA_CONF_DIR/server.xml && \
    rm server.xslt

ENV WDBUILDER /wd/root

RUN mkdir -p $WDBUILDER/usr/share && \
    mkdir -p $WDBUILDER/startup/startup.d && \
    cp /startup/startup.d/setup-tomcat* $WDBUILDER/startup/startup.d && \
    cp -R $CATALINA_HOME $WDBUILDER/usr/share

#
# The actual image definition
#
FROM ${DOCKER_HUB_PUBLIC}/cafapi/opensuse-jre8:4

RUN zypper -n refresh && \
    zypper -n update && \
    zypper -n clean --all

ENV CATALINA_HOME /usr/share/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
WORKDIR $CATALINA_HOME

HEALTHCHECK CMD curl --fail http://localhost:8081/healthcheck || exit 1

EXPOSE 8080 8081 8443
CMD ["catalina.sh", "run"]

COPY --from=builder /wd/root/ /
