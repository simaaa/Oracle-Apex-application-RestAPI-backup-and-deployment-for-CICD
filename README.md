# Oracle Apex application RestAPI backup and deployment for CI/CD
This is a simple solution for quickly backing up and deploying Apex applications using RestAPI /ORDS/. You can use this for CI/CD.
## Description
You can backup and deploy Oracle Apex applications very simple with curl commands. The RestAPI solution is defnied in ORDS and Apex applications are managed using an Oracle database stored procedures (package). To use basic authentication, we create an APEX workspace with users, for separate backup and deployment.

## Usage
#### Linux:
```
curl -X GET \
  --user deploy:secret \
  --remote-name \
  --remote-header-name \
  -H "Accept: application/sql" \
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```
#### Windows:
```
curl -X GET ^
  --user deploy:secret ^
  --remote-name ^
  --remote-header-name ^
  -H "Accept: application/sql" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```

## Requirements
This solution requires a working [Oracle Application Express - APEX](https://apex.oracle.com)
([Oracle REST Data Services - ORDS](https://www.oracle.com/database/technologies/appdev/rest.html))

## Installation
[Installation](install/README.md)

## Security
Execute scripts as APEX_ADMIN database user.
#### Basic authentication with Apex workspace users
```
40_secure_backup_with_apex_account.pdc
40_secure_deploy_with_apex_account.pdc
```

#### Oauth authentication
```
41_oauth_install_backup.pdc
41_oauth_install_deploy.pdc
```
