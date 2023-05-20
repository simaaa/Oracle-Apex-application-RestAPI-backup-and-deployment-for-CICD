## Installation
### Oracle database user Apex workspace
Execute scripts as SYS database user.
```
10_create_user__as_sys.pdc
11_create_apex_workspace__as_sys.pdc
```
### Database stored procedure - APEX_APP_DEPLOY package
Execute scripts as APEX_ADMIN database user.
```
20_load_stored_procedure.pdc
```
### Oracle ORDS configuration
Execute scripts as APEX_ADMIN database user.
```
30_enable_ords_schema.pdc
```
### Create ORDS Rest Modules
Execute scripts as APEX_ADMIN database user.
#### Backup Rest Module
```
31_create_rest_module_backup.pdc
```
#### Deploy Rest Module
```
31_create_rest_module_deploy.pdc
```

