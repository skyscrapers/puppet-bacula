#!/bin/bash

## THIS FILE IS PUPPETIZED, CHANGES WILL BE OVERWRITTEN EVENTUALLY
## CONTACT A SYSADMIN TO CHANGE SETTINGS IN HERE

TOTALERRORS=0

if [ -x /root/scripts/mysqlbackup.sh ]; then
	/root/scripts/mysqlbackup.sh
	if [ $? -ne 0 ]; then
  	TOTALERRORS=$(expr $TOTALERRORS + 1)
  fi
fi

if [ -x /root/scripts/rdsbackup.sh ]; then
  /root/scripts/rdsbackup.sh
  if [ $? -ne 0 ]; then
    TOTALERRORS=$(expr $TOTALERRORS + 1)
  fi
fi

if [ -x /root/scripts/elasticsearchbackup.sh ]; then
  /root/scripts/elasticsearchbackup.sh
  if [ $? -ne 0 ]; then
    TOTALERRORS=$(expr $TOTALERRORS + 1)
  fi
fi

if [ -x /root/scripts/mongodbbackup.sh ]; then
	/root/scripts/mongodbbackup.sh
	if [ $? -ne 0 ]; then
		TOTALERRORS=$(expr $TOTALERRORS + 1)
	fi
fi

if [ $TOTALERRORS == 0 ]; then
  exit 0
else
  exit 2
fi
