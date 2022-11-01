!not-ready-for-release!

#### Version Number
${version-number}

#### New Features
- US353761: Security hardening techniques introduced.
  - Tomcat now running as a non-root user.
  - Everything from CATALINA_HOME/webapps removed. 
  - Default servlet now configured to serve index pages when a welcome file is not present. Parameters defined in web.xml.
  - Default error page has been overridden in web.xml, as the default error message returns a full stacktrace of information (disclosing sensitive information).
  - Server version string has been replaced from HTTP headers in server responses in server.xslt.

#### Known Issues
