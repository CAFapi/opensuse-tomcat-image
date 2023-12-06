#### Version Number
${version-number}

#### New Features
- US866084: Tomcat updated to version [9.0.83](https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.83/README.html).  
This resolves [CVE-2023-46589](http://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2023-46589)

#### Bug Fixes
- I860022: Fixed password replacement bug in setup-tomcat-ssl-cert.sh  
Replaced the `sed` command used to replace passwords in setup-tomcat-ssl-cert.sh with `awk`, as the `sed` command failed when the password contained the `@` symbol.

#### Known Issues
- None
