## Usage
Services: [Backup](USAGE.md#backup), [Delete](USAGE.md#delete), [Deploy (import)](/USAGE.md#deploy-import), [Oauth example](/USAGE.md#oauth-example)

## Security
At least basic authentication is strongly recommended. Use without authentication is not recommended!
- #### Basic authentication: '--user <apex_workspace_user_name>:<apex_workspace_user_password>"
- #### Oauth authentication: '-H "Authorization: Bearer <previously_queried_token>"'
## Backup

#### Linux:
```
curl -X GET --remote-name --remote-header-name \
  --user deploy:secret \
  -H "Accept: application/sql" \
  http://localhost:8080/ords-pdb1/admin/backup/app/666
  
curl -X GET --remote-name --remote-header-name \
  --user deploy:secret \
  -H "Accept: application/zip" \
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```
#### Windows:
```
curl -X GET --remote-name --remote-header-name ^
  --user deploy:secret ^
  -H "Accept: application/sql" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
  
curl -X GET --remote-name --remote-header-name ^
  --user deploy:secret ^
  -H "Accept: application/zip" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```

## Delete
#### Configuration parameter in the header:
- X-Target-Workspace: Apex workspace name where the application to be deleted is located
```
curl -X DELETE ^
  --user deploy:secret ^
  -H "X-Target-Workspace: APEX_ADMIN" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```

## Deploy (import)
#### Configuration parameters in the header:
- X-Target-Workspace: Apex workspace name where to deploy/import the file
- Content-Type: Importable file type, sql or zip ("application/sql", "application/zip")
```
curl -X PUT ^
  --user deploy:secret ^
  -H "X-Target-Workspace: APEX_ADMIN" ^
  -H "Content-Type: application/sql" ^
  --data-binary @f666.sql ^
  http://localhost:8080/ords-pdb1/admin/deploy/app/666
```

## Oauth example
#### Requirements:
- Oauth installation for backup and/or deploy using installation scripts (41_oauth_install_backup.pdc, 41_oauth_install_deploy.pdc)
- HTTP SSL configuration for ORDS on the server to request oauth token
- ["jq" solution](https://stedolan.github.io/jq) for parsing json content ([install on Winddows](https://bobbyhadz.com/blog/install-and-use-jq-on-windows))

```
@Echo Off
SET CLIENT_ID=4iPHoc4n7eShh9H_XvZMnA..
SET CLIENT_SECRET=22KDuJRLSJcuamKPE-9XNw..
FOR /F %%I in ('
curl -X POST ^
  --user "%CLIENT_ID%:%CLIENT_SECRET%" ^
  --data-raw "grant_type=client_credentials" ^
  --insecure ^
  https://localhost:8080/ords-pdb1/admin/oauth/token ^| jq -r ".access_token"
') DO SET OAUTH_TOKEN=%%I
ECHO OAUTH_TOKEN=%OAUTH_TOKEN%

curl -X GET --remote-name --remote-header-name ^
  -H "Authorization: Bearer %OAUTH_TOKEN%" ^
  -H "Accept: application/sql" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```
