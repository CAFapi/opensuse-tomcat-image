!not-ready-for-release!

#### Version Number
${version-number}

#### New Features
- The image is now based on [openSUSE Leap 15.3](https://en.opensuse.org/Portal:15.3).  
The release notes for openSUSE Leap 15.3 can be found [here](https://doc.opensuse.org/release-notes/x86_64/openSUSE/Leap/15.3/).
- SCMOD-13983: Tomcat updated to version [9.0.46](https://mirrors.ukfast.co.uk/sites/ftp.apache.org/tomcat/tomcat-9/v9.0.46/README.html).
- SCMOD-14011: Updated to support file-based secrets  
  The image now comes pre-installed with a startup script which provides support for file-based secrets. It works by looking for
  environment variables ending with the _FILE prefix and setting the environment variable base name to the contents of the file. For
  example, given this environment variable ending in the _FILE suffix: `ABC_PASSWORD_FILE=/var/somefile.txt`, the script will read the
  contents of /var/somefile.txt (for example 'mypassword'), and export an environment variable named ABC_PASSWORD:
  `ABC_PASSWORD=mypassword`

#### Bug fixes
 - SCMOD-13334: [Tomcat Base Image Issue #41](https://github.com/CAFapi/opensuse-tomcat-image/issues/41): Tomcat-Juli Jar Causes java.lang.NoClassDefFoundError: Could not initialize class org.postgresql.Driver

#### Known Issues
- None
