## Usage
Services: Backup, Delete, Deploy (import)

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
