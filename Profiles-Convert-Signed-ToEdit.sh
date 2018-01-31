#!/bin/bash

#Convert Signed/Encrypted profiles to unsigned so they can be edited#

/usr/bin/security cmd -D -I /path/to/signed_profile.mobileconfig -o /path/to/unsigned_profile.mobileconfig