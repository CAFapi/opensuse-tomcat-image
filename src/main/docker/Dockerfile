#
# Copyright 2015-2017 EntIT Software LLC, a Micro Focus company.
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

#
# Preliminary image that downloads Tomcat and makes some modifications
#
FROM opensuse:latest AS builder
RUN zypper -n install tar xsltproc
WORKDIR /usr/share/
COPY apache-tomcat-8.5.23.tar.gz .
RUN tar xzf apache-tomcat-8.5.23.tar.gz
WORKDIR apache-tomcat-8.5.23/
RUN rm -rf webapps/docs/ webapps/examples/ webapps/host-manager/ webapps/manager/

# Overwrite the main logging configuration file
# (It is being copied to a temporary folder first, and then overwritten using cp, in order to retain the original file's permissions.)
COPY logging.properties /tmp/tomcat/conf/
RUN cp /tmp/tomcat/conf/logging.properties conf/

# Apply the specified transform to the server.xml file
COPY server.xslt /tmp/tomcat/conf/
RUN cp conf/server.xml /tmp/tomcat/conf/
RUN xsltproc -o conf/server.xml /tmp/tomcat/conf/server.xslt /tmp/tomcat/conf/server.xml

#
# The actual image definition
#
FROM cafapi/opensuse-jre8:1.0

COPY --from=builder /usr/share/apache-tomcat-8.5.23/ /usr/share/apache-tomcat-8.5.23/

WORKDIR /usr/share/

RUN ln -s apache-tomcat-8.5.23 tomcat && \
    groupadd tomcat && \
    useradd -s /bin/bash -g tomcat tomcat && \
    chown -Rf tomcat.tomcat /usr/share/tomcat

# Tag the image
ARG BUILD_NUMBER
ARG BUILD_DATE
ARG GIT_REPO
ARG GIT_BRANCH
ARG GIT_COMMIT

LABEL Build.Number="$BUILD_NUMBER" \
      Build.Date="$BUILD_DATE" \
      Git.Repo="$GIT_REPO" \
      Git.Branch="$GIT_BRANCH" \
      Git.Commit="$GIT_COMMIT"
