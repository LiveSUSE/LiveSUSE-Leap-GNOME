#!/bin/bash

#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Mount system filesystems
#--------------------------------------
baseMount

#======================================
# Call configuration code/functions
#--------------------------------------

# Setup baseproduct link
suseSetupProduct

# Add missing gpg keys to rpm
suseImportBuildKey

# Activate services
suseInsertService sshd
if [[ ${kiwi_type} =~ oem|vmx ]];then
    suseInsertService grub_config
else
    suseRemoveService grub_config
fi

# Setup default target, multi-user
baseSetRunlevel 3

# Official repositories
# (as found in http://download.opensuse.org/distribution/leap/15.0/repo/oss/control.xml)
rm /etc/zypp/repos.d/*.repo
zypper addrepo -f -K -n "openSUSE-Leap-15.0-Update" http://download.opensuse.org/update/leap/15.0/oss/ repo-update
zypper addrepo -f -K -n "openSUSE-Leap-15.0-Update-Non-Oss" http://download.opensuse.org/update/leap/15.0/non-oss/ repo-update-non-oss
zypper addrepo -f -K -n "openSUSE-Leap-15.0-Oss" http://download.opensuse.org/distribution/leap/15.0/repo/oss/ repo-oss
zypper addrepo -f -K -n "openSUSE-Leap-15.0-Non-Oss" http://download.opensuse.org/distribution/leap/15.0/repo/non-oss/ repo-non-oss
zypper addrepo -d -K -n "openSUSE-Leap-15.0-Debug" http://download.opensuse.org/debug/distribution/leap/15.0/repo/oss/ repo-debug
zypper addrepo -d -K -n "openSUSE-Leap-15.0-Debug-Non-Oss" http://download.opensuse.org/debug/distribution/leap/15.0/repo/non-oss/ repo-debug-non-oss
zypper addrepo -d -K -n "openSUSE-Leap-15.0-Update-Debug" http://download.opensuse.org/debug/update/leap/15.0/oss repo-debug-update
zypper addrepo -d -K -n "openSUSE-Leap-15.0-Update-Debug-Non-Oss" http://download.opensuse.org/debug/update/leap/15.0/non-oss/ repo-debug-update-non-oss
zypper addrepo -d -K -n "openSUSE-Leap-15.0-Source" http://download.opensuse.org/source/distribution/leap/15.0/repo/oss/ repo-source
zypper addrepo -d -K -n "openSUSE-Leap-15.0-Source-Non-Oss" http://download.opensuse.org/source/distribution/leap/15.0/repo/non-oss/ repo-source-non-oss

# SuSEconfig
suseConfig

#======================================
# Umount kernel filesystems
#--------------------------------------
baseCleanMount

#======================================
# Exit safely
#--------------------------------------

exit 0
