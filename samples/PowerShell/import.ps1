$ORDS_HOST = 'localhost:8443'
$ORDS_CONTEXT = '/ords-pdb1'
$ORDS_SCHEMA_ALIAS = 'admin'
$APEX_WORKSPACE = 'APEX_ADMIN'
$APP_ID=666

## Getting token
$user = 'cguAyvdIUgsk6--vsQhiaQ..'
$pass = 'aUtGYcK6f5blqKospXvrMw..'
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)"))
$headers=@{ "Authorization" = "Basic $encodedCreds" }

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$response = Invoke-WebRequest -Method POST -Headers $headers -Body 'grant_type=client_credentials' -Uri "https://$ORDS_HOST$ORDS_CONTEXT/$ORDS_SCHEMA_ALIAS/oauth/token"
$jsonObj = ConvertFrom-Json $([String]::new($response.Content))
$token = $jsonObj.access_token
$token

## Import application
$headers2=@{}
$headers2.Add('Authorization', "Bearer $token")
$headers2.Add('Content-Type', 'application/sql')
$headers2.Add('X-Target-Workspace', "$APEX_WORKSPACE")
$response2 = Invoke-WebRequest -Method PUT -Headers $headers2 -Infile "f$APP_ID.sql" -Uri "https://$ORDS_HOST$ORDS_CONTEXT/$ORDS_SCHEMA_ALIAS/deploy/app/$APP_ID"
$response2.StatusCode

TIMEOUT /T 3
