@Echo Off
TITLE REQUEST OAUTH TOKEN FROM ORDS
SET ORDS_HOST=localhost:8443
SET ORDS_CONTEXT=/ords-pdb1
SET ORDS_SCHEMA_ALIAS=admin


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


TIMEOUT /T 3
