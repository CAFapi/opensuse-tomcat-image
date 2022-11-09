!not-ready-for-release!

#### Version Number
${version-number}

#### New Features
- US353761: Security hardening techniques introduced.
  - Tomcat now running as a non-root user.
  - Everything from CATALINA_HOME/webapps removed. 
  - CATALINA_HOME/conf file permissions set to read only (400)
  - CATALINA_HOME/logs permissions set to write access (300)
  - Default servlet now configured to serve index pages when a welcome file is not present. Parameters defined in web.xslt.
  - Default error page has been overridden in web.xml using the web.xslt, as the default error message returns a full stacktrace of information (disclosing sensitive information).
  - Server version string has been replaced from HTTP headers in server responses in server.xslt.
  - Tomcat running with a security manager ensuring a webapplication isn't able to read/write/execute any file on the local filesystem without altering catalina.policy.

#### Known Issues
