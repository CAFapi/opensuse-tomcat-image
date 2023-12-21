<?xml version="1.0" encoding="utf-8"?>
<!--

    Copyright 2017-2024 Open Text.

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

    <!-- Override the main application access logging element -->
    <xsl:template match="/Server/Service[@name='Catalina']/Engine[@name='Catalina']/Host[@name='localhost']/Valve[@className='org.apache.catalina.valves.AccessLogValve']">
        <xsl:copy>
            <xsl:attribute name="className">ch.qos.logback.access.tomcat.LogbackValve</xsl:attribute>
            <xsl:attribute name="quiet">true</xsl:attribute>
        </xsl:copy>
    </xsl:template>

    <!-- Override the admin application access logging element -->
    <xsl:template match="/Server/Service[@name='CatalinaAdmin']/Engine[@name='CatalinaAdmin']/Host[@name='localhost']/Valve[@className='org.apache.catalina.valves.AccessLogValve']">
        <xsl:copy>
            <xsl:attribute name="className">ch.qos.logback.access.tomcat.LogbackValve</xsl:attribute>
            <xsl:attribute name="quiet">true</xsl:attribute>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
