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
    <xsl:strip-space elements="*"/>

    <!-- Copy the entire xml file -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!--Ensures the default servlet is configured not to serve index pages when a welcome file is not present.-->
    <xsl:template match="web-app/servlet/init-param[param-name='listings']/param-value">
        <param-value>false</param-value>
    </xsl:template>

    <!--Replacement of the default error page to produce a blank page for security coverage.-->
    <!--The default error page shows a full stacktrace, disclosing sensitive information.-->
    <xsl:template match="web-app/welcome-file-list">
        <xsl:apply-templates/>
        <error-page>
            <exception-type>java.lang.Throwable</exception-type>
            <!-- Not the real /dev/null, but the effect is the same. Capture stack
                 traces to non-existent file before output makes is back to a
                 nefarious user.-->
            <location>/dev/null</location>
        </error-page>
    </xsl:template>

</xsl:stylesheet>