#!/bin/bash
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
# This script replaces the log level value in logging.properties with CAF_LOG_LEVEL
#
if [ -n "${CAF_LOG_LEVEL}" ]
then
    echo "Replacing log level in $CATALINA_HOME/conf/logging.properties with provided environment variable CAF_LOG_LEVEL"
    sed -i "/org\.apache\.catalina\.core\.ContainerBase\.\[Catalina\]\.\[localhost\]\.level =/ s/=.*/= ${CAF_LOG_LEVEL}/" $CATALINA_HOME/conf/logging.properties
fi