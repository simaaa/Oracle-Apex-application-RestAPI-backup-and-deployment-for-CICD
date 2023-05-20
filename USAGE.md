## Usage
Services: backup, delete, import

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
```
curl -X DELETE ^
  --user deploy:secret ^
  -H "X-Target-Workspace: APEX_ADMIN" ^
  http://localhost:8080/ords-pdb1/admin/backup/app/666
```

## Deploy (import)
```
curl -X PUT ^
  --user %BASIC_AUTH% ^
  -H "X-Target-Workspace: %WORKSPACE%" ^
  -H "Content-Type: application/sql" ^
  --data-binary @f%APP_ID%.sql ^
  http://localhost:8080/ords-pdb1/admin/deploy/app/666

```
