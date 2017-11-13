#### Version Number
${version-number}

#### New Features
 - Logging to standard output streams  
    The Tomcat configuration has been updated so that all logs are sent to the standard output streams.  The access logs are prefixed with `access_log> ` so that they can be easily filtered.

 - Administration port added  
    Port 8081 has been exposed for service administration functionality.  Consumers are expected to supply a `/healthcheck` endpoint on the admin port but can also use this port to expose other administration functions.

 - Automatic TLS configuration  
    The Tomcat TLS configuration is now automatically updated from environment variables when the container starts up.

##### Inherited from base image
 - Startup script drop-in directory  
    A facility has been added for automatically running startup scripts. Any executable scripts added to the `/startup/startup.d/` folder will automatically be run each time the container is started (assuming the image entrypoint is not overwritten).

 - Automatic certificate installation  
    Startup scripts which provide a mechanism to extend the CA certificates which should be trusted have been pre-installed.

#### Breaking Changes
 - Health Check Application Required  
    Consumers of this image must provide a second web application that was not previously required.  The application should be installed into the `adminapps` directory as described in the README file, and it should provide a `/healthcheck` endpoint which can be used to determine whether the service is healthy.

#### Known Issues
 - None
