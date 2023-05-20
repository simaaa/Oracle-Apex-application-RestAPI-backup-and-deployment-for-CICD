@Echo Off
TITLE EXPORT APEX APPLICATION WITH OAUTH
SET ORDS_HOST=localhost:8080
SET ORDS_CONTEXT=/ords-pdb1
SET ORDS_SCHEMA_ALIAS=admin
SET BASIC_AUTH=backup:secret
SET APP_ID=666


:: GET OAUTH TOKEN
SET CLIENT_ID=4iPHoc4n7eShh9H_XvZMnA..
SET CLIENT_SECRET=22KDuJRLSJcuamKPE-9XNw..
FOR /F %%I in ('
curl -X POST ^
  --user "%CLIENT_ID%:%CLIENT_SECRET%" ^
  --data-raw "grant_type=client_credentials" ^
  --insecure ^
  https://%ORDS_HOST%%ORDS_CONTEXT%/%ORDS_SCHEMA_ALIAS%/oauth/token ^| jq -r ".access_token"
') DO SET TOKEN=%%I
ECHO.
ECHO TOKEN=%TOKEN%
ECHO %TOKEN% > token.txt


:: EXPORT WITH OAUTH TOKEN
SET /P OAUTH_TOKEN=<token.txt
ECHO OAUTH_TOKEN=%OAUTH_TOKEN%
curl -X GET ^
  -H "Authorization: Bearer %OAUTH_TOKEN%" ^
  http://%ORDS_HOST%%ORDS_CONTEXT%/%ORDS_SCHEMA_ALIAS%/backup/app/%APP_ID% > f%APP_ID%.sql


TIMEOUT /T 3
