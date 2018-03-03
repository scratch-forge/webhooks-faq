## OAuth2 Login

### 2-legged Authentication

It is typical client server scenario without any user involvement for authentication. For ex. one of your server is directly talking to Forge APIs without requiring user involvement.

* You get `Client ID` and `Client Secret` when you create a Autodesk Forge App.
* Using the `Client ID` and `Client Secret`, you request for an **authentication token** from Forge.
* Forge returns a **token** (with an expiry interval) after validating `Client ID` and `Client Secret`.
* While making Forge API calls, you will provide the obtained **token** as signature.

Lets try to obtain a token for our use:
1. Copy your `Client ID` and `Client Secret` of your Forge App. See [Create an App](/part-1_create_app) section for more details.
2. Run following command after replacing **<Client_ID>** with your Forge App's `Client ID`
  On Mac:
  ```
  export FORGE_CLIENT_ID=<Client_ID>
  ```
3. Run following command after replacing **<Client_Secret>** with your Forge App's `Client Secret`
  On Mac:
  ```
  export FORGE_CLIENT_SECRET=<Client_Secret>
  ```
4. Use Client ID and Secret to obtain an Access Token

  ```
  curl 'https://developer.api.autodesk.com/authentication/v1/authenticate' \
    -X 'POST' \
    -H 'Content-Type:application/x-www-form-urlencoded' \
    -d "client_id=$FORGE_CLIENT_ID&client_secret=$FORGE_CLIENT_SECRET&grant_type=client_credentials&scope=data:read data:write"
  ```

  You should see response similar to:

  ```
  {
      "access_token": "eyJhbGciOiJIUzI1NiIsImtpZCI6Imp3dF9zeW1tZXRyaWNfa2V5In0.eyJjbGllbnRfaWQiOiJsZHpWODYwS0pHWkF6a1JJZGlsZE8yQUFFOU4yYWRTYiIsImV4cCI6MTUyMDA5NzI5MCwic2NvcGUiOlsiZGF0YTpyZWFkIiwiZGF0YTp3cml0ZSJdLCJhdWQiOiJodHRrcz0vL2F1dG9kZXNrLmNvbS9hdWQvand0ZXhwNjAiLCJqdGkiOiJ5SGxIVUVCUWZjVm80VlRMY0ppb0NkZExYMDA1Y1drcEs2T2RGbjdVbjFBOWxxZ2VFd00yYXV1U1Y2b3Bma1d6In0._j7226WkYsXY241b5nrrLbWei5g_JsFiRIBSK1g_Z9M",
      "token_type": "Bearer",
      "expires_in": 3599
  }
  ```
  You can now use the token `access_token` to make calls to Forge API endpoints that require the `data:read` and `data:write` scope


### 3-legged Authentication with Authorization Code Grant

It is for scenario where an user involvement for authentication is required. If you need an end user to authorize your app to act on the user’s behalf.

Lets try to obtain a 3-legged token for our use:

1. Copy your `Client ID` and `Client Secret` of your Forge App. See [Create an App](/part-1_create_app) section for more details.
2. Run following command after replacing **<Client_ID>** with your Forge App's `Client ID`
  On Mac:

  ```
  export FORGE_CLIENT_ID=<Client_ID>

  # example:
  # export FORGE_CLIENT_ID=ldzV860KJGZBzkRIdildO2AAE9N2adSb
  ```

3. Run following command after replacing **<Client_Secret>** with your Forge App's `Client Secret`

  On Mac:
  ```
  export FORGE_CLIENT_SECRET=<Client_Secret>

  # example:
  # export FORGE_CLIENT_SECRET=qEJRfDyiaOerRAU7
  ```

4. Run following command after replacing **<CallBack_URL>** with your Forge App's `CallBack URL`

  On Mac:
  ```
  export FORGE_CALLBACK_URL=<CallBack_URL>

  # example:
  # export FORGE_CALLBACK_URL=export FORGE_CALLBACK_URL=https://67aa2b97.ngrok.io/auth
  ```

4. Run following command in terminal:
  On Mac:

  ```
  open "https://developer.api.autodesk.com/authentication/v1/authorize?response_type=code&client_id=$FORGE_CLIENT_ID&redirect_uri=$FORGE_CALLBACK_URL&scope=data:read data:write"
  ```

  Or, open link directly in a browser by replacing FORGE_CLIENT_ID and FORGE_CALLBACK_URL.

  ```
  https://developer.api.autodesk.com/authentication/v1/authorize?response_type=code&client_id=FORGE_CLIENT_ID&redirect_uri=FORGE_CALLBACK_URL&scope=data:read data:write
  ```

5. You should notice Autodesk sign-in dialog after few seconds. Provide an user credentials.
  Note: The user credential can be of any user who has [Autodesk ID](https://accounts.autodesk.com/).

  ![Get Token 1](../image/12.png)

6. After successful login, user should grant access to your Forge application to access his/her data stored on Autodesk server.

  ![Get Token 2](../image/13.png)

7. After that, you should notice a `code` as query parameter to your callback URL `FORGE_CALLBACK_URL`.
  ![Get Token 2](../image/14.png)

  If you are using `grok` then you can access the code by opening [Web Interface](http://127.0.0.1:4040/inspect/http).

  ![Get Token 2](../image/15.png)

  While developing your application, your app should extract this code query parameter value and store it in a temporary variable.

  For this example, set it as environment variable:
  ```
  export FORGE_CALLBACK_CODE=<CODE>
  ```

8. Exchange this code for Access Token by running the following command:

  ```
  curl 'https://developer.api.autodesk.com/authentication/v1/gettoken' \
    -X 'POST' \
    -H 'Content-Type:application/x-www-form-urlencoded' \
    -d "client_id=$FORGE_CLIENT_ID&client_secret=$FORGE_CLIENT_SECRET&grant_type=authorization_code&code=$FORGE_CALLBACK_CODE&redirect_uri=$FORGE_CALLBACK_URL"
  ```

  You should see response similar to:

  ```
  {
    "access_token":"eyJhbGciOiJIUzI1NiIsImtpZCI6Imp3dF9zeW1tZXRyaWNfa2V5In0.eyJ1c2VyaWQiOiJUS0FVUFY1VkE3OFIiLCJleHAiOjE1MjAxMDEwMTQsInNjb3BlIjpbImRhdGE6d3JpdGUiLCJkYXRhOnJlYWQiXSwiY2xpZW50X2lkIjoibGR6Vjg2NEtKR1pBemtSSWRpbGRPMkFBRTlOMmFkU2IiLCJncmFudF9pZCI6IkY0VlFYY3BKbGhpcmRKOXJEOFlZS0VnVjNKYUFBSG9xIiwiYXVkIjoiaHR0cHM6Ly9hdXRvZGVzay5jb20vYXVkL2p3dGV4cDYwIiwianRpIjoiQ3hUdjlEbnc5VkZTbKkwMnRYazFLS3U3cnR0alZNUk53WTU4QmJaTzk0ZU1tRFVwSE9GTFY0b0QxWDhHb3NrZCJ9.qSOtEB7IN9Bn8XBtdnxXjFQp2qApLkodYVdPYmGtoYU",
    "refresh_token":"LhEUcXjqsEZoewV6sgIp4yPTH4TKDa0GejPRIxG1u",
    "token_type":"Bearer",
    "expires_in":3599
  }
  ```

  You can now use the token `access_token` to make calls to Forge API endpoints that require the `data:read` and `data:write` scope (on user's behalf)
