# Red Hat PAM (Proces Automation Manager) Install

This repo is used to install Red Hat Process Automation Manager on Mac OSX.

## Requisits
* An account on access.redhat.com
* Admin access on the install machine

## Tested Environment
* Mac OSX High Sierra 10.13

## Step By Step Instructions

1. Install brew, the Mac OSX Package manager, on your mac.
```
/install-brew.sh/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2. Clone this repository, if necessary, and make the shell scripts executable
```
git clone https://github.com/pacificera/minishift-pam-install.git
chmod 755 *.sh
```

3. Install minishift
```
./install-minishift.sh
```

4. Download the RH PAM Openshift Templates and Unpack them

Open a browser and navigate to (RH PAM Openshift Templates)[https://access.redhat.com/jbossnetwork/restricted/softwareDownload.html?softwareId=60281&product=rhpam].

Note that this step requires authentification on access.redhat.com.

Unpack this archive in the directory containing this README.  The subdirectory is specified in the install-pam script

5. Configure minishift
```
./configure-minishift.sh
```

Be sure to note the url for your Openshift Console at the end of the run of this script.  For example:

```
The server is accessible via web console at:
    https://192.168.64.11:8443
```

6. Install PAM
```
./install-pam
```
