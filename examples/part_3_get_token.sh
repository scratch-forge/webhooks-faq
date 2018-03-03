export FORGE_CLIENT_ID=<Replace with Client ID>
export FORGE_CLIENT_SECRET=<Replace with Client Secret>

# export FORGE_CLIENT_ID=ldzV860KJGZBzkRIdildO2AAE9N2adSb
# export FORGE_CLIENT_SECRET=qEJRfDyiaOerRAU7

# Command to get OAUth2 2-Legged token
curl 'https://developer.api.autodesk.com/authentication/v1/authenticate' -X 'POST' -H 'Content-Type:application/x-www-form-urlencoded' -d "client_id=$FORGE_CLIENT_ID&client_secret=$FORGE_CLIENT_SECRET&grant_type=client_credentials&scope=data:read data:write"

# Command to get OAUth2 3-Legged token
curl 'https://developer.api.autodesk.com/authentication/v1/authenticate' -X 'POST' -H 'Content-Type:application/x-www-form-urlencoded' -d "client_id=$FORGE_CLIENT_ID&client_secret=$FORGE_CLIENT_SECRET&grant_type=client_credentials&scope=data:read data:write"
