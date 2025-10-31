CREATE PROCEDURE ImportarInquilinos_Propietarios
	@RutaArchivoNovedades VARCHAR(500)
AS BEGIN
    CREATE TABLE #DatosImportadosCSV(
        Nombre VARCHAR(100),
        Apellido VARCHAR(100),
        Documento INT,
        Email_Personal VARCHAR(100),
        Telefono INT,
    );
    --
    DECLARE @ComandoSQL NVARCHAR(MAX);
    SET @ComandoSQL = 
        'BULK INSERT #DatosImportadosCSV
        FROM ''' + @RutaArchivoNovedades + '''
        WITH (
            FIELDTERMINATOR = '';'',
            ROWTERMINATOR = ''\n'',
            FIRSTROW = 2
        )';
    --
    BEGIN TRY
        EXEC sp_executesql @ComandoSQL;
    END TRY
    BEGIN CATCH
        PRINT 'ERROR AL EJECUTAR BULK INSERT. Revise la ruta del archivo y los permisos.';
        RETURN;
    END CATCH;
    --
    MERGE Persona AS Transformado
    USING (
        SELECT DISTINCT
            1 AS Tipo_Documento,
            DatoImportado.Documento AS Numero_Documento,
            TRIM(REPLACE(DatoImportado.Nombre, '''', '')) AS Nombre,
            TRIM(REPLACE(DatoImportado.Apellido, '''', '')) AS Apellido,
            TRIM(DatoImportado.Email_Personal) AS Correo_Electronico,
            CAST(TRIM(DatoImportado.Telefono) AS INT) AS Telefono
        FROM #DatosImportadosCSV AS DatoImportado
    ) AS Fuente 
    ON (
        Transformado.numero_documento = Fuente.Numero_Documento AND Transformado.tipo_documento = Fuente.Tipo_Documento
    )
    --
    WHEN MATCHED THEN
        UPDATE SET
            Transformado.nombre = Fuente.Nombre,                 -- Se actualiza el nombre por si hubo corrección
            Transformado.apellido = Fuente.Apellido,             -- Se actualiza el apellido
            Transformado.correo_electronico = Fuente.Correo_Electronico,
            Transformado.Telefono = Fuente.Telefono
    --
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (tipo_documento, numero_documento, nombre, apellido, correo_electronico, Telefono)
        VALUES (
            Fuente.Tipo_Documento, -- Se inserta la constante 1
            Fuente.Numero_Documento,
            Fuente.Nombre,
            Fuente.Apellido,
            Fuente.Correo_Electronico,
            Fuente.Telefono
        );
    --
    IF OBJECT_ID('tempdb..#DatosImportadosCSV') IS NOT NULL
    DROP TABLE #NovedadesCSV;
END
