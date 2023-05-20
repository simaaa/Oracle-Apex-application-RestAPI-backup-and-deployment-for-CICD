CREATE OR REPLACE PACKAGE APEX_APP_DEPLOY IS

-- ####################################################################################################
-- ORDS Module installation configuration

  -- Backup
  GC_ORDS_BK_MODULE_NAME             CONSTANT VARCHAR2(1000) := 'apex.app.backup';
  GC_ORDS_BK_MODULE_PATH             CONSTANT VARCHAR2(1000) := 'backup/app/';
  GC_ORDS_BK_PRIVILEGE_NAME          CONSTANT VARCHAR2(1000) := 'apex.app.backup.priv';
  GC_ORDS_BK_ROLE_NAME               CONSTANT VARCHAR2(1000) := 'ORDS_ROLE_BACKUP';
  GC_ORDS_BK_OAUTH_CLIENT_NAME       CONSTANT VARCHAR2(1000) := 'APEX Apps Backup Client Credential';
  GC_ORDS_BK_OAUTH_ROLE_NAME         CONSTANT VARCHAR2(1000) := 'apex.app.backup.oauth.role';
  GC_ORDS_BK_OAUTH_PRIVILEGE_NAME    CONSTANT VARCHAR2(1000) := 'apex.app.backup.oauth.priv';

  -- Deployment
  GC_ORDS_MODULE_NAME             CONSTANT VARCHAR2(1000) := 'apex.app.deploy';
  GC_ORDS_MODULE_PATH             CONSTANT VARCHAR2(1000) := 'deploy/app/';
  GC_ORDS_PRIVILEGE_NAME          CONSTANT VARCHAR2(1000) := 'apex.app.deploy.priv';
  GC_ORDS_ROLE_NAME               CONSTANT VARCHAR2(1000) := 'ORDS_ROLE_DEPLOY';
  GC_ORDS_OAUTH_CLIENT_NAME       CONSTANT VARCHAR2(1000) := 'APEX Apps Deployment Client Credential';
  GC_ORDS_OAUTH_ROLE_NAME         CONSTANT VARCHAR2(1000) := 'apex.app.deploy.oauth.role';
  GC_ORDS_OAUTH_PRIVILEGE_NAME    CONSTANT VARCHAR2(1000) := 'apex.app.deploy.oauth.priv';

-- ####################################################################################################

-- ====================================================================================================
-- Is the ORDS module installed
-- ----------------------------------------------------------------------------------------------------
FUNCTION is_module_exists RETURN BOOLEAN;

-- ====================================================================================================
-- Getter for ORDS backup oauth client name
-- ----------------------------------------------------------------------------------------------------
FUNCTION get_backup_oauth_client_name RETURN VARCHAR2;

-- ====================================================================================================
-- Getter for ORDS deploy oauth client name
-- ----------------------------------------------------------------------------------------------------
FUNCTION get_deploy_oauth_client_name RETURN VARCHAR2;

-- ====================================================================================================
-- Delete Apex application
--
-- Parameters:
--   p_in_workspace       if provided, delete application in this workspace
--   p_application_id     Application ID to be deleted; extension will be ignored.
-- ----------------------------------------------------------------------------------------------------
PROCEDURE delete(
  p_in_workspace        IN  VARCHAR2 DEFAULT NULL,
  p_application_id      IN  NUMBER
);

-- ====================================================================================================
-- Export Apex application or application components, as SQL or ZIP file.
--
-- Parameters:
--   p_application_id     Application ID to be exported
--   p_components         Only export the specified components; use syntax
--                        of APEX_EXPORT.GET_APPLICATION procedure; components
--                        separated by comma.
--   p_mimetype           mimetype of the expected target file. Supports .sql or .zip
--                        and .json in the future. Overrides the suffix specified
--                        in p_application_file.
-- ----------------------------------------------------------------------------------------------------
PROCEDURE export(
  p_application_id      IN  VARCHAR2,
  p_components          IN  VARCHAR2,
  p_mimetype            IN  VARCHAR2
);

-- ====================================================================================================
-- Import Apex application or application components, as SQL or ZIP file
--
-- Parameters:
--   p_export_file        Export file
--   p_mimetype           Mime Type of the export file, to determine whether 
--                        this is ZIP or SQL
--   p_application_id     Import file as this application ID
--   p_to_workspace       if provided, import into this workspace
-- ----------------------------------------------------------------------------------------------------
PROCEDURE import(
  p_export_file         IN  BLOB,
  p_mimetype            IN  VARCHAR2,
  p_to_workspace        IN  VARCHAR2 DEFAULT NULL,
  p_application_id      IN  NUMBER DEFAULT NULL
);

END;
/

CREATE OR REPLACE PACKAGE BODY APEX_APP_DEPLOY IS

-- ####################################################################################################

-- ====================================================================================================
-- Is the ORDS module installed
-- ----------------------------------------------------------------------------------------------------
FUNCTION is_module_exists RETURN BOOLEAN IS
  l_temp        NUMBER;
BEGIN
  SELECT 1 INTO l_temp FROM user_ords_modules t WHERE t.name = GC_ORDS_MODULE_NAME;
  RETURN TRUE;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN FALSE;
END;

-- ====================================================================================================
-- Getter for ORDS backup oauth client name
-- ----------------------------------------------------------------------------------------------------
FUNCTION get_backup_oauth_client_name RETURN VARCHAR2 IS
BEGIN
  RETURN GC_ORDS_BK_OAUTH_CLIENT_NAME;
END;

-- ====================================================================================================
-- Getter for ORDS deploy oauth client name
-- ----------------------------------------------------------------------------------------------------
FUNCTION get_deploy_oauth_client_name RETURN VARCHAR2 IS
BEGIN
  RETURN GC_ORDS_OAUTH_CLIENT_NAME;
END;

-- ====================================================================================================
PROCEDURE set_workspace(
  p_workspace           IN  VARCHAR2
) IS
BEGIN
    IF p_workspace IS NULL THEN
        RAISE_APPLICATION_ERROR(-20000, 'The Apex workspace name not defined!');
    END IF;
    APEX_UTIL.set_workspace( p_workspace );
    APEX_APPLICATION_INSTALL.set_workspace( p_workspace );
END;

-- ####################################################################################################

-- ====================================================================================================
PROCEDURE delete(
  p_in_workspace        IN  VARCHAR2 DEFAULT NULL,
  p_application_id      IN  NUMBER
) IS
BEGIN
    set_workspace( p_workspace => p_in_workspace );
    APEX_APPLICATION_INSTALL.remove_application( p_application_id => p_application_id );
END;

-- ====================================================================================================
PROCEDURE export(
  p_application_id      IN  VARCHAR2,
  p_components          IN  VARCHAR2,
  p_mimetype            IN  VARCHAR2
) IS
    l_files_sql         apex_t_export_files;
    l_files             apex_t_export_files;
    l_components        apex_t_varchar2 := CASE WHEN p_components IS NULL THEN NULL ELSE APEX_STRING.split( ltrim(rtrim(p_components)), ',' ) END;
    l_blob              BLOB;
    l_as_zip            BOOLEAN := LOWER( p_mimetype ) = 'application/zip';
    l_download_filename VARCHAR2(100) := 'f' || p_application_id;
BEGIN
    /*IF p_components IS NOT NULL THEN
        l_components := APEX_STRING.split( ltrim(rtrim( p_components ) ) , ',' );
    END IF;*/
    
    IF l_as_zip THEN
        l_files_sql := APEX_EXPORT.get_application(
            p_application_id => TO_NUMBER( p_application_id ),
            p_type           => APEX_EXPORT.c_type_application_source,
            p_components     => l_components );
    END IF;

    l_files := APEX_EXPORT.get_application(
        p_application_id => TO_NUMBER( p_application_id ),
        p_type           => CASE WHEN l_as_zip THEN APEX_EXPORT.c_type_readable_yaml ELSE APEX_EXPORT.c_type_application_source END,
        p_components     => l_components );

    DBMS_LOB.createtemporary(
        lob_loc => l_blob,
        cache   => TRUE,
        dur     => DBMS_LOB.call );

    IF l_as_zip THEN
        APEX_ZIP.add_file(
            p_zipped_blob => l_blob,
            p_file_name   => l_files_sql(1).name,
            p_content     => APEX_UTIL.clob_to_blob(l_files_sql(1).contents) );
        FOR i IN 1 .. l_files.count LOOP
            APEX_ZIP.add_file(
                p_zipped_blob => l_blob,
                p_file_name   => l_files(i).name,
                p_content     => APEX_UTIL.clob_to_blob(l_files(i).contents) );
        END LOOP;
        APEX_ZIP.finish( l_blob );
        l_download_filename := l_download_filename || '.zip';
        OWA_UTIL.mime_header( 'application/zip', false );
    ELSE
        l_blob := APEX_UTIL.clob_to_blob( l_files(1).contents );
        l_download_filename := l_download_filename || '.sql';
        OWA_UTIL.mime_header( 'application/sql', false );
    END IF;

    HTP.p( 'Content-Length: ' || DBMS_LOB.getlength( l_blob ) );
    HTP.p( 'Content-Disposition: attachment; filename=' || l_download_filename );
    OWA_UTIL.http_header_close;
    WPG_DOCLOAD.download_file( l_blob );
END;

-- ====================================================================================================
PROCEDURE import(
  p_export_file         IN  BLOB,
  p_mimetype            IN  VARCHAR2,
  p_to_workspace        IN  VARCHAR2 DEFAULT NULL,
  p_application_id      IN  NUMBER DEFAULT NULL
) IS
    l_files             apex_t_export_files := apex_t_export_files();
    l_zip_files         APEX_ZIP.t_files;
BEGIN
    set_workspace( p_workspace => p_to_workspace );

    IF LOWER( p_mimetype ) = 'application/zip' THEN
        l_zip_files := APEX_ZIP.get_files( p_zipped_blob => p_export_file, p_only_files  => TRUE );
        l_files.extend( l_zip_files.count );
        FOR i IN 1 .. l_zip_files.count LOOP
            l_files( i ) := apex_t_export_file(
                l_zip_files( i ),
                APEX_UTIL.blob_to_clob(
                    APEX_ZIP.get_file_content(
                        p_zipped_blob => p_export_file, p_file_name => l_zip_files(i) ) ) );
        END LOOP;
    ELSE
        l_files.extend(1);
        l_files(1) := apex_t_export_file( 'import-data.sql', APEX_UTIL.blob_to_clob( p_export_file ) );
    END IF;

    APEX_APPLICATION_INSTALL.set_application_id( p_application_id => p_application_id );
    APEX_APPLICATION_INSTALL.install( p_source => l_files, p_overwrite_existing => TRUE );
END;

END;
/
