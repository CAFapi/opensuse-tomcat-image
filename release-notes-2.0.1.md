#### Version Number
${version-number}

#### New Features
 - None

#### Bug Fixes

##### Inherited from base image
 - Corrected Java certificate installation issue  
    The pre-installed certificate installation scripts have been re-ordered so that the base OS certificate installation script runs first, before the script which installs the certificates for Java.  This is to avoid an issue whereby the base OS script was undoing some of the work done by the Java script.

#### Known Issues
 - None
