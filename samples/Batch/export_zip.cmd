@Echo Off
TITLE EXPORT APEX APPLICATION
SET ORDS_HOST=localhost:8080
SET ORDS_CONTEXT=/ords-pdb1
SET ORDS_SCHEMA_ALIAS=admin
SET BASIC_AUTH=backup:secret
SET APP_ID=666


curl -X GET ^
  --user %BASIC_AUTH% ^
  --remote-name ^
  --remote-header-name ^
  -H "Accept: application/zip" ^
  http://%ORDS_HOST%%ORDS_CONTEXT%/%ORDS_SCHEMA_ALIAS%/backup/app/%APP_ID%


TIMEOUT /T 3
