#!/bin/bash

# PUPPETIZED

# Don't want to use vars because rm -rf of an empty var can be dangerous :)
# I'll check for the existance of the folders though

if [ -d "/tmp/bacula-restores" ]; then
	/bin/rm -rf /tmp/bacula-restores
fi

if [ -d "/tmp/remoteCopy" ]; then
        /bin/rm -rf /tmp/remoteCopy
fi

if [ -d "/tmp/exportDB" ]; then
        /bin/rm -rf /tmp/exportDB
fi
