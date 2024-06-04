#!/bin/zsh

#########################################################################################
# Generate Bearer Token to access API information
#########################################################################################

# Set Jamf Pro Paramters
# Parameter 4 = Jamf Pro API User
# Parameter 5 = Jamf Pro API Password

authDetails=$(cat "${script_directory}/api_credentials.csv")

if [ "${1}" = "debug" ]
then
	echo "${authDetails}"
fi

#Setting Jamf Pro User details from file#

JAMF_PRO_API_WRITE_USER=$(echo "${authDetails}" | cut -d',' -f1)
JAMF_PRO_API_WRITE_PASS=$(echo "${authDetails}" | cut -d',' -f2)
JAMF_PRO_URL=$(echo "${authDetails}" | cut -d',' -f3)

# Check to see if a value was passed in parameter 4 and 5
if [[ $4 != "" ]]; then
    jamfpro_user=$JAMF_PRO_API_WRITE_USER
    if [[ "$5" != "" ]]; then
        jamfpro_password=$JAMF_PRO_API_WRITE_PASS
    else
        echo "Parameter 5 not set, exiting..."
        exit 1
    fi
else
    echo "Parameter 4 not set, exiting..."
    exit 1
fi

#jamfpro_url=$(/usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url | sed 's|/$||')

jamfpro_url="${JAMF_PRO_URL}"

GetJamfProAPIToken() {
    # This function uses Basic Authentication to get a new bearer token for API authentication.
    # Create base64-encoded credentials from user account's username and password.
    encodedCredentials=$(printf "${jamfpro_user}:${jamfpro_password}" | /usr/bin/iconv -t ISO-8859-1 | /usr/bin/base64 -i -)
            
    # Use the encoded credentials with Basic Authorization to request a bearer token
    auth_token=$(/usr/bin/curl "${jamfpro_url}/api/v1/auth/token" --silent --request POST --header "Authorization: Basic ${encodedCredentials}")
        
    # Parse the returned output for the bearer token and store the bearer token as a variable.
    if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
        api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$auth_token" | /usr/bin/xargs)
    else
        api_token=$(/usr/bin/plutil -extract token raw -o - - <<< "$auth_token")
    fi
}

APITokenValidCheck() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.
    api_authentication_check=$(/usr/bin/curl --write-out %{http_code} --silent --output /dev/null "${jamfpro_url}/api/v1/auth" --request GET --header "Authorization: Bearer ${api_token}")
}

CheckAndRenewAPIToken() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.
    APITokenValidCheck

    # If the api_authentication_check has a value of 200, that means that the current
    # bearer token is valid and can be used to authenticate an API call.
    if [[ ${api_authentication_check} == 200 ]]; then
        # If the current bearer token is valid, it is used to connect to the keep-alive endpoint. This will
        # trigger the issuing of a new bearer token and the invalidation of the previous one.
        #
        # The output is parsed for the bearer token and the bearer token is stored as a variable.
        auth_token=$(/usr/bin/curl "${jamfpro_url}/api/v1/auth/keep-alive" --silent --request POST --header "Authorization: Bearer ${api_token}")
        if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
            api_token=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$auth_token" | /usr/bin/xargs)
        else
            api_token=$(/usr/bin/plutil -extract token raw -o - - <<< "$auth_token")
        fi
    else
        # If the current bearer token is not valid, this will trigger the issuing of a new bearer token
        # using Basic Authentication.
        GetJamfProAPIToken
    fi
}

InvalidateToken() {
    # Verify that API authentication is using a valid token by running an API command
    # which displays the authorization details associated with the current API user. 
    # The API call will only return the HTTP status code.
    APITokenValidCheck
    # If the api_authentication_check has a value of 200, that means that the current
    # bearer token is valid and can be used to authenticate an API call.
    if [[ ${api_authentication_check} == 200 ]]; then
        # If the current bearer token is valid, an API call is sent to invalidate the token.
        auth_token=$(/usr/bin/curl "${jamfpro_url}/api/v1/auth/invalidate-token" --silent  --header "Authorization: Bearer ${api_token}" -X POST)
        # Explicitly set value for the api_token variable to null.
        api_token=""
    fi
}

GetJamfProVersion() {
    jamfProProductVersion=$(/usr/bin/curl "${jamfpro_url}/api/v1/jamf-pro-version" --silent  --header "Authorization: Bearer ${api_token}" -X GET)
    if [[ $(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}') -lt 12 ]]; then
        jamf_pro_version=$(/usr/bin/awk -F \" 'NR==2{print $4}' <<< "$jamfProProductVersion" | /usr/bin/xargs)
    else
        jamf_pro_version=$(/usr/bin/plutil -extract version raw -o - - <<< "$jamfProProductVersion")
    fi
}

# Get Jamf Pro Bearer Token
echo "Getting Jamf Pro Bearer Token..."
GetJamfProAPIToken
APITokenValidCheck
echo "HTTP Code: $api_authentication_check"
echo "Bearer Token: $api_token"

echo ""

# Get Jamf Pro Version
echo "Getting Jamf Pro Version..."
GetJamfProVersion
echo "Jamf Pro Version: $jamf_pro_version"

echo ""

# Check Jamf Pro Bearer Token
echo "Checking Jamf Pro Bearer Token..."
CheckAndRenewAPIToken
APITokenValidCheck
echo "HTTP Code: $api_authentication_check"
echo "Bearer Token: $api_token"

echo ""

# Invalidate Jamf Pro Bearer Token
echo "Invalidating Jamf Pro Bearer Token..."
InvalidateToken
APITokenValidCheck
echo "HTTP Code: $api_authentication_check"
echo "Bearer Token: $api_token"