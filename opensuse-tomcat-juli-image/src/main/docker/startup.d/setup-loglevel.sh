#!/bin/bash
#
# Copyright 2017-2023 Open Text.
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

# This script replaces the log level value in logging.properties if environment variable CAF_LOG_LEVEL is set
#
#Declare and initialize associative array. This is a mapping of log4j2 levels with that of java.util.logging
declare -A LOG4J2TOJAVAmap=([FATAL]=SEVERE [ERROR]=SEVERE [WARN]=WARNING [DEBUG]=FINE [TRACE]=FINEST)
if [ -n "${CAF_LOG_LEVEL}" ]
then
    #if CAF_LOG_LEVEL is not set right we default it to INFO
    LOGLEVEL=INFO
    if [ -n "${LOG4J2TOJAVAmap[${CAF_LOG_LEVEL^^}]}" ]
    then
        LOGLEVEL=${LOG4J2TOJAVAmap[${CAF_LOG_LEVEL^^}]}
    fi
    echo "Environment log level variable set CAF_LOG_LEVEL:${CAF_LOG_LEVEL}"
    echo "Replacing log level in $CATALINA_HOME/conf/logging.properties with equivalent log level:${LOGLEVEL}"
    sed -i "/org\.apache\.catalina\.core\.ContainerBase\.\[Catalina\]\.\[localhost\]\.level =/ s/=.*/= ${LOGLEVEL}/" \
        $CATALINA_HOME/conf/logging.properties
fi
