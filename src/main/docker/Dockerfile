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

FROM rh7-artifactory.svs.hpeswlab.net:8444/base-images/opensuse-java:20171010

ADD http://apache.mirrors.lucidnetworks.net/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz /usr/share

WORKDIR /usr/share/

RUN ln -s apache-tomcat-8.5.23 tomcat && \
    groupadd tomcat && \
    useradd -s /bin/bash -g tomcat tomcat && \
    chown -Rf tomcat.tomcat /usr/share/tomcat && \
    rm -rf /usr/share/tomcat/webapps/manager  && \
    rm -rf /usr/share/tomcat/webapps/docs && \
    rm -rf /usr/share/tomcat/webapps/examples && \
    rm -rf /usr/share/tomcat/webapps/host-manager

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
