$ORDS_HOST = 'localhost:8443'
$ORDS_CONTEXT = '/ords-pdb1'
$ORDS_SCHEMA_ALIAS = 'admin'
$APP_ID = 666

## Getting token
$user = '5u0wsUhAOQBRJyMqiqfelw..'
$pass = 'bwBdCw0P3BX24WvrXeKAMg..'
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)"))
$headers=@{ "Authorization" = "Basic $encodedCreds" }

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$response = Invoke-WebRequest -Method POST -Headers $headers -Body 'grant_type=client_credentials' -Uri "https://$ORDS_HOST$ORDS_CONTEXT/$ORDS_SCHEMA_ALIAS/oauth/token"
$jsonObj = ConvertFrom-Json $([String]::new($response.Content))
$token = $jsonObj.access_token
$token

## Export application
$headers2=@{}
$headers2.Add('Authorization', "Bearer $token")
$headers2.Add('Accept', 'application/sql')
Invoke-WebRequest -Method GET -Headers $headers2 -Uri "https://$ORDS_HOST$ORDS_CONTEXT/$ORDS_SCHEMA_ALIAS/backup/app/$APP_ID" -OutFile f$APP_ID.sql

TIMEOUT /T 3
