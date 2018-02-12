#!/bin/sh

# This script binds to AD and configures advanced options of the AD plugin
# As this scripts contains a password, be sure to take appropriate security
# precautions

echo "AD BIND: Setting up AD Binding preferences"

##########################################################################################
##########################################################################################
### START of configuration ###############################################################


# Host-specific parameters
# computerid should be set dynamically, this value must be machine-specific
# This value may be restricted to 19 characters! The only error you'll receive upon entering
# an invalid computer id is to the effect of not having appropriate privileges to perform the requested operation

#Alternative Ways of getting value#
#computerid=`/sbin/ifconfig en0 | awk '/ether/ { gsub(":", ""); print $2 }'` # Use the MAC Address
#computerid=`hostname`
#computerid=`/usr/sbin/scutil --get LocalHostName | cut -c 1-19` # Assure that this will produce unique names!

computerid=`/usr/sbin/scutil --get LocalHostName`

# Standard parameters
domain="org.com.au"            # fully qualified DNS name of Active Directory Domain
udn="binduser"                # username of a privileged network user
password="password"                # password of a privileged network user
ou="CN=Computers,DC=org,DC=com,DC=au"        # Distinguished name of container for the computer

# Advanced options
alldomains="enable"            # 'enable' or 'disable' automatic multi-domain authentication
localhome="disable"            # 'enable' or 'disable' force home directory to local drive
protocol="smb"                # 'afp' or 'smb' change how home is mounted from server
mobile="enable"            # 'enable' or 'disable' mobile account support for offline logon
mobileconfirm="disable"            # 'enable' or 'disable' warn the user that a mobile acct will be created
useuncpath="disable"            # 'enable' or 'disable' use AD SMBHome attribute to determine the home dir
user_shell="/bin/bash"            # e.g., /bin/bash or "none"
preferred="-nopreferred"        # Use the specified server for all Directory lookups and authentication
                      			# (e.g. "-nopreferred" or "-preferred ad.server.edu")
admingroups="domain admins,enterprise admins"                # These comma-separated AD groups may administer the machine (e.g. "" or "APPLE\mac admins")
packetsign="allow"            # allow | disable | require
packetencrypt="allow"            # allow | disable | require

#DNS Update Restrictions Settings#
#Used to prevent unwanted IP addresses from being added to the AD DNS records#
IPSub="0.0.0." #Subnet that should be present when enforcing restriction, i.e "192.168.1." for 192.168.1.1-254 or "10.9." for the entire 10.9.0.0 -> 10.9.254.254 range
enDNS="en0" #Interface to check and restrict to, i.e. en0, en1, etc

### End of configuration #################################################################
##########################################################################################
##########################################################################################


#Synchronize network time to allow joining to domain

echo "Time Check 1:"
date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S"

echo "...Tuning off time sync..."
systemsetup -setusingnetworktime off

sleep 2

echo "...Tuning on time sync..."
systemsetup -setusingnetworktime on

#Allow time for NTP synchronization

sleep 2

echo "Time Check 2:"
date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S"

#Check if currently bound and 

BindCheck=`/usr/sbin/dsconfigad -show | grep "Active Directory Domain" | awk '{print $5}'`

if [ "$BindCheck" == "$domain" ]; then

echo "...Un-Binding From AD..."
/usr/sbin/dsconfigad -remove -force -u $udn -p "$password"

fi

# Activate the AD plugin
echo "...Activating AD Plugin..."
defaults write /Library/Preferences/DirectoryService/DirectoryService "Active Directory" "Active"
plutil -convert xml1 /Library/Preferences/DirectoryService/DirectoryService.plist

# Bind to AD
echo "...Attempting to Bind..."
/usr/sbin/dsconfigad -f -a $computerid -domain $domain -u $udn -p "$password" -ou "$ou"


# Configure advanced AD plugin options
echo "...Setting Admin Groups..."
if [ "$admingroups" = "" ]; then
/usr/sbin/dsconfigad -nogroups
else
/usr/sbin/dsconfigad -groups "$admingroups"
fi

echo "...Setting AD preferences..."
/usr/sbin/dsconfigad -alldomains $alldomains -localhome $localhome -protocol $protocol \
-mobile $mobile -mobileconfirm $mobileconfirm -useuncpath $useuncpath \
-shell $user_shell $preferred -packetsign $packetsign -packetencrypt $packetencrypt

#Check if on the correct LAN via the correct port to restrict DNS#
IPCheck=`ifconfig "$enDNS" | grep "inet $IPSub"`

if [ -n "$IPCheck" ]; then

echo "...Restricting AD DNS to $enDNS..."
/usr/sbin/dsconfigad -restrictDDNS "$enDNS"

else

echo "...$enDNS not active on the desired LAN, leaving DNS unrestricted"

fi

# Add the AD node to the search path
if [ "$alldomains" = "enable" ]; then
csp="/Active Directory/All Domains"
else
csp="/Active Directory/$domain"
fi

echo "...Adding Search Paths..."
defaults write /Library/Preferences/DirectoryService/SearchNodeConfig "Search Node Custom Path Array" -array "$csp"
defaults write /Library/Preferences/DirectoryService/SearchNodeConfig "Search Policy" -int 3
plutil -convert xml1 /Library/Preferences/DirectoryService/SearchNodeConfig.plist

#Disable Password Expiration Prompt

/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow PasswordExpirationDays -int 0

exit 0
