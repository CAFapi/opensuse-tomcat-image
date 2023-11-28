!not-ready-for-release!

#### Version Number
${version-number}

#### New Features
- None

#### Bug Fixes
- 860022: Fixed password replacement bug in setup-tomcat-ssl-cert.sh  
Replaced the `sed` command used to replace passwords in setup-tomcat-ssl-cert.sh with `awk`, as the `sed` command failed when the password contained the `@` symbol.

#### Known Issues
- None
