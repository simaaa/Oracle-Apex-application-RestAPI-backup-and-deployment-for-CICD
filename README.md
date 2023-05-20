# Oracle Apex application RestAPI backup and deployment for CI/CD
This is a simple solution for quickly backing up and deploying Apex applications using RestAPI /ORDS/. You can use this for CI/CD.
## Description
You can backup and deploy Oracle Apex applications very simple with curl commands. The RestAPI solution is defnied in ORDS and Apex applications are managed using an Oracle database stored procedures (package). To use basic authentication, we create an APEX workspace with users, for separate backup and deployment.

## Usage
#### RestAPI configuration
- ##### Apex application id
Defined in the url, for example when application id=666: ````http://localhost:8080/ords-pdb1/admin/backup/app/666````
- ##### Authentication
Set the username and password for basic authentication with curl ````--user```` parameter or in the http header when using oauth.
- ##### Backup content type
Set the backup type in the "Accept" header variable using the following.
- application/sql: Apex application backup in sql script format
- application/zip: Apex application backup in yaml compressed format (zip)
#### Linux:
```
curl -X GET --remote-name --remote-header-name \
  --user backup:secret \
  -H "Accept: application/sql" \
  http://localhost:8080/ords-pdb1/admin/backup/app/666
  
curl -X GET --remote-name --remote-header-name \
  --user backup:secret \
  -H "Accept: application/zip" \
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```
#### Windows:
```
curl -X GET --remote-name --remote-header-name ^
  --user backup:secret ^
  -H "Accept: application/sql" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
  
curl -X GET --remote-name --remote-header-name ^
  --user backup:secret ^
  -H "Accept: application/zip" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```
[Additional usage examples](USAGE.md)

## Requirements
This solution requires a working [Oracle Application Express - APEX](https://apex.oracle.com)
([Oracle REST Data Services - ORDS](https://www.oracle.com/database/technologies/appdev/rest.html))

For deleting and importing Apex application in different Apex workspace, the APEX_ADMIN database user required APEX_ADMINISTRATOR_ROLE database role.
```
GRANT APEX_ADMINISTRATOR_ROLE TO APEX_ADMIN;
```

## Installation
[Installation](install/README.md)

## Security
For security settings, run the following scripts with APEX_ADMIN database user
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
