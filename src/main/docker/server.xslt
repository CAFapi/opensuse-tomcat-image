<?xml version="1.0" encoding="utf-8"?>
<!--

    Copyright 2015-2017 EntIT Software LLC, a Micro Focus company.

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

    <!-- Override the specified access logging element -->
    <xsl:template match="/Server/Service[@name='Catalina']/Engine[@name='Catalina']/Host[@name='localhost']/Valve[@className='org.apache.catalina.valves.AccessLogValve']">
        <xsl:copy>
            <xsl:attribute name="className">
                <xsl:value-of select="@className" />
            </xsl:attribute>
            <xsl:attribute name="directory">/dev</xsl:attribute>
            <xsl:attribute name="prefix">stdout</xsl:attribute>
            <xsl:attribute name="rotatable">false</xsl:attribute>
            <xsl:attribute name="pattern">access_log> <xsl:value-of select="@pattern" /></xsl:attribute>
            <xsl:attribute name="encoding">UTF-8</xsl:attribute>
            <xsl:attribute name="buffered">false</xsl:attribute>
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
                    <Valve className="org.apache.catalina.valves.AccessLogValve"
                           directory="/dev"
                           prefix="stdout"
                           rotatable="false"
                           encoding="UTF-8"
                           buffered="false">
                        <xsl:attribute name="pattern">admin_access_log> <xsl:value-of
                            select="Engine[@name='Catalina']/Host[@name='localhost']/Valve[@className='org.apache.catalina.valves.AccessLogValve']/@pattern" />
                        </xsl:attribute>
                    </Valve>
                </Host>
            </Engine>
        </Service>
    </xsl:template>
</xsl:stylesheet>
