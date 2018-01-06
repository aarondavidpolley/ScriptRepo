#!/bin/bash

#Test Local User#
/usr/bin/dscl . auth <username> <password>

#Test Local LDAP Directory User#
/usr/bin/dscl /LDAPv3/127.0.0.1 auth <username> <password>