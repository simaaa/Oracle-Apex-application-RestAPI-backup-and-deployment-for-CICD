$ORDS_HOST = 'localhost:8443'
$ORDS_CONTEXT = '/ords-pdb1'
$ORDS_SCHEMA_ALIAS = 'admin'
$APP_ID = 666

## Getting token
$user = 'WOjUmaA6k4UNV_663Zcb4Q..'
$pass = 'b2zgZEyHosVbFaLCqh8BtA..'
$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($user):$($pass)"))
$headers=@{ "Authorization" = "Basic $encodedCreds" }

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$response = Invoke-WebRequest -Method POST -Headers $headers -Body 'grant_type=client_credentials' -Uri "https://$ORDS_HOST$ORDS_CONTEXT/$ORDS_SCHEMA_ALIAS/oauth/token"
$jsonObj = ConvertFrom-Json $([String]::new($response.Content))
$token = $jsonObj.access_token
$token

TIMEOUT /T 3
