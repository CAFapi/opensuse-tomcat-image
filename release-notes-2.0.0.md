!not-ready-for-release!

#### Version Number
${version-number}

#### New Features

#### Breaking Changes
 - Health Check Application Required  
    Consumers of this image must provide a second web application that was not previously required.  The application should be installed into the `adminapps` directory as described in the README file, and it should provide a `/healthcheck` endpoint which can be used to determine whether the service is healthy.

#### Known Issues
