@Echo Off
TITLE IMPORT APEX APPLICATION
SET ORDS_HOST=localhost:8080
SET ORDS_CONTEXT=/ords-pdb1
SET ORDS_SCHEMA_ALIAS=admin
SET BASIC_AUTH=deploy:secret
SET WORKSPACE=APEX_ADMIN
SET APP_ID=666


SET /P AREYOUSURE=Are you sure to IMPORT AND OVERRIDE Apex application (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO:EOF


curl -X PUT ^
  --user %BASIC_AUTH% ^
  -H "X-Target-Workspace: %WORKSPACE%" ^
  -H "Content-Type: application/sql" ^
  --data-binary @f%APP_ID%.sql ^
  http://%ORDS_HOST%%ORDS_CONTEXT%/%ORDS_SCHEMA_ALIAS%/deploy/app/%APP_ID%


PAUSE
