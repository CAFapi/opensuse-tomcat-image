<?xml version="1.0" encoding="utf-8"?>
<!--

    Copyright 2017-2022 Micro Focus or one of its affiliates.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" />

    <!-- Copy the entire xml file -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Add in the commented out SSL section that the setup-tomcat-ssl-cert.sh startup script expects to be present -->
    <xsl:template match="/Server/Service[@name='Catalina']/Connector[@port='8080']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <xsl:text>

    </xsl:text><xsl:comment>
            A connector with SSL enabled. The commenting lines below will be removed by the setup-tomcat-ssl-cert.sh script. This
            connector uses the NIO implementation that requires the JSSE style configuration. When using the APR/native implementation,
            the OpenSSL style configuration is required as described in the APR/native documentation
    </xsl:comment><xsl:text>
    </xsl:text><xsl:comment> setup-tomcat-ssl-cert.sh TLS section start
    &lt;Connector port="8443"
               protocol="org.apache.coyote.http11.Http11NioProtocol"
               SSLEnabled="true"
               scheme="https"
               secure="true"
               keystoreFile="/keystore/tomcat.keystore"
               keystorePass="changeit"
               keyPass="changeit"
               clientAuth="false"
               keyAlias="tomcat"
               sslProtocol="TLS" />
    setup-tomcat-ssl-cert.sh TLS section end </xsl:comment><xsl:text>
    </xsl:text>
    </xsl:template>

    <!-- Override the specified access logging element -->
    <xsl:template match="/Server/Service[@name='Catalina']/Engine[@name='Catalina']/Host[@name='localhost']/Valve[@className='org.apache.catalina.valves.AccessLogValve']">
        <xsl:copy>
            <xsl:attribute name="className">ch.qos.logback.access.tomcat.LogbackValve</xsl:attribute>
            <xsl:attribute name="quiet">true</xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!-- Add an ErrorReportValve to stop display of stack trace and server info in error pages -->
    <xsl:template match="/Server/Service[@name='Catalina']/Engine[@name='Catalina']/Host[@name='localhost']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
            <Valve className="org.apache.catalina.valves.ErrorReportValve" showReport="false" showServerInfo="false" />
        </xsl:copy>
    </xsl:template>

    <!-- Add an administration port -->
    <xsl:template match="/Server/Service[@name='Catalina']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
        <Service name="CatalinaAdmin">
            <Connector port="8081" protocol="HTTP/1.1">
                <!-- Copy the connection timeout from the main connector -->
                <xsl:attribute name="connectionTimeout">
                    <xsl:value-of select="Connector[@port='8080']/@connectionTimeout" />
                </xsl:attribute>
            </Connector>
            <Engine name="CatalinaAdmin" defaultHost="localhost">
                <Host name="localhost" appBase="adminapps" autoDeploy="false">
                    <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true">
                    </Valve>
                </Host>
            </Engine>
        </Service>
    </xsl:template>
</xsl:stylesheet>
