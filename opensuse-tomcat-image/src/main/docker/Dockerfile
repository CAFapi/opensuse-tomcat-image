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
FROM ${DOCKER_HUB_PUBLIC}/cafapi/prereleases:opensuse-tomcat-base-image-5.7.0-US590035a-SNAPSHOT AS base-image
RUN zypper -n install xsltproc
ENV CATALINA_HOME /usr/share/tomcat

ENV CATALINA_CONF_DIR $CATALINA_HOME/conf
ENV CATALINA_BIN_DIR $CATALINA_HOME/bin
ENV CATALINA_LIB_DIR $CATALINA_HOME/lib

ENV PATH $CATALINA_BIN_DIR:$PATH

WORKDIR $CATALINA_HOME

RUN rm -rf /wd/root/usr/share/tomcat/conf/logging.properties

# Copy new logback.xml and logback-access.xml to tomcat conf folder for logback implementation
COPY logback*.xml $CATALINA_CONF_DIR/

# Copy new setenv.bat and setenv.sh to tomcat bin folder
COPY setenv.* $CATALINA_BIN_DIR/

# Copy a new lib folder with thirdparty jars for logback implementation to tomcat lib folder
COPY /maven/lib/*.jar $CATALINA_LIB_DIR/
WORKDIR $CATALINA_HOME
RUN mv $CATALINA_LIB_DIR/caf-logging-tomcat-juli-5.7.0-SNAPSHOT.jar $CATALINA_BIN_DIR/tomcat-juli.jar

# Apply the specified transform to the server.xml file
COPY server.xslt .
RUN cp $CATALINA_CONF_DIR/server.xml .
RUN xsltproc -o $CATALINA_CONF_DIR/server.xml server.xslt server.xml

HEALTHCHECK CMD curl --fail http://localhost:8081/healthcheck || exit 1

EXPOSE 8080 8081 8443
CMD ["catalina.sh", "run"]
