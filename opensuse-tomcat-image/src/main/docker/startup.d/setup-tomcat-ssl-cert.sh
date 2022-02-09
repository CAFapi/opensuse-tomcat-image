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

#
# This script is based on the following script with only very minor changes:
# https://github.com/CAFapi/caf-common/blob/v1.14.0/container-cert-script/setup-tomcat-ssl-cert.sh
#
# - References to "/usr/local/tomcat" have been replaced with "$CATALINA_HOME"
# - The entire script has been wrapped in a check for SSL_TOMCAT_CA_CERT_LOCATION
#

# If there is a provided tomcat keystore
if [ -n "${SSL_TOMCAT_CA_CERT_LOCATION}" ]
then
    echo "Tomcat CA Cert provided at location: ${SSL_TOMCAT_CA_CERT_LOCATION}"

    # search for and delete the lines in the server.xml with:
    # <!-- setup-tomcat-ssl-cert.sh TLS section start
    # setup-tomcat-ssl-cert.sh TLS section end -->
    echo "Uncommenting SSL connector in $CATALINA_HOME/conf/server.xml"
    sed -i '/setup-tomcat-ssl-cert.sh TLS section start/d' $CATALINA_HOME/conf/server.xml
    sed -i '/setup-tomcat-ssl-cert.sh TLS section end/d' $CATALINA_HOME/conf/server.xml

    # Replace the default keystore with the SSL_TOMCAT_CA_CERT_LOCATION keystore provided
    echo "Replacing default keystore in $CATALINA_HOME/conf/server.xml with provided environment variable SSL_TOMCAT_CA_CERT_LOCATION."
    sed -i "s@keystoreFile=.*@keystoreFile=\"$SSL_TOMCAT_CA_CERT_LOCATION\"@" $CATALINA_HOME/conf/server.xml

    # Replace default password with a user defined password if provided
    if [ -n "${SSL_TOMCAT_CA_CERT_KEYSTORE_PASS}" ]
    then
        echo "Replacing keystore pass in $CATALINA_HOME/conf/server.xml with provided environment variable SSL_TOMCAT_CA_CERT_KEYSTORE_PASS"
        sed -i "s@keystorePass=.*@keystorePass=\"$SSL_TOMCAT_CA_CERT_KEYSTORE_PASS\"@" $CATALINA_HOME/conf/server.xml
    fi

    # Replace default password with a user defined password if provided
    if [ -n "${SSL_TOMCAT_CA_CERT_KEY_PASS}" ]
    then
        echo "Replacing key pass in $CATALINA_HOME/conf/server.xml with provided environment variable SSL_TOMCAT_CA_CERT_KEY_PASS"
        sed -i "s@keyPass=.*@keyPass=\"$SSL_TOMCAT_CA_CERT_KEY_PASS\"@" $CATALINA_HOME/conf/server.xml
    fi

    # Replace default alias with a user defined alias if provided
    if [ -n "${SSL_TOMCAT_CA_CERT_KEYSTORE_ALIAS}" ]
    then
        echo "Replacing keystore alias in $CATALINA_HOME/conf/server.xml with provided environment variable SSL_TOMCAT_CA_CERT_KEYSTORE_ALIAS"
        sed -i "s@keyAlias=.*@keyAlias=\"$SSL_TOMCAT_CA_CERT_KEYSTORE_ALIAS\"@" $CATALINA_HOME/conf/server.xml
    fi
fi
