#!/bin/bash

#Convert Signed/Encrypted profiles to unsigned so they can be edited#
#Pre 10.13#

/usr/bin/security cmd -D -I /path/to/signed_profile.mobileconfig -o /path/to/unsigned_profile.mobileconfig

#post 10.13#

/usr/bin/security cms -D -i /path/to/signed_profile.mobileconfig -o /path/to/unsigned_profile.mobileconfig

#Make more human readable formatting#

/usr/bin/plutil -convert xml1 /path/to/unsigned_profile.mobileconfig