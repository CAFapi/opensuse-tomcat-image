#!/bin/bash
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

set -e

if [ "$1" = 'start-tomcat.sh' ] || [ "$1" = 'catalina.sh' ]; then

    # Switch user from root to user tomcat using gosu
    # Gosu required to allow setup-tomcat-ssl-cert.sh to run as root
    # Set-up certificates cannot be run with non-root permissions

    USER_ID=${TOMCAT_USER_ID:-1000}
    GROUP_ID=${TOMCAT_GROUP_ID:-1000}

    ###
    # Tomcat user
    ###
    groupadd -r tomcat -g ${GROUP_ID} && \
    useradd -u ${USER_ID} -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin \
        -c "Tomcat user" tomcat

    ###
    # Change CATALINA_HOME ownership to tomcat user and tomcat group
    # Restrict permissions on conf to read only
    ###

    chown -R tomcat:tomcat ${CATALINA_HOME} && chmod 400 ${CATALINA_HOME}/conf/*
    sync

    exec gosu tomcat "$@"

fi

exec "$@"
