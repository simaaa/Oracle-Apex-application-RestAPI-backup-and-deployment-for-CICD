# Oracle Apex application RestAPI backup and deployment for CI/CD
This is a simple solution for quickly backing up and deploying Apex applications using RestAPI /ORDS/. You can use this for CI/CD.
## Description
You can backup and deploy Oracle Apex applications very simple with curl commands.

## Installation
### Oracle database user Apex workspace
```
10_create_user__as_sys.pdc
11_create_apex_workspace__as_sys.pdc
```
### Database stored procedure - APEX_APP_DEPLOY package
```
20_load_stored_procedure.pdc
```
### Oracle ORDS configuration
```
30_enable_ords_schema.pdc
```
### Create ORDS Rest Modules
#### Backup Rest Module
```
31_create_rest_module_backup.pdc
```
#### Deploy Rest Module
```
31_create_rest_module_deploy.pdc
```

