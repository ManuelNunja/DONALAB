USE DB_DONALABWEB
GO

-- Primero, intenta crear el esquema MAESTRO
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'MAESTRO')
BEGIN
    EXEC('CREATE SCHEMA MAESTRO');
END;

-- Crear la tabla PARAMETRO en el esquema MAESTRO
CREATE TABLE MAESTRO.PARAMETRO (
    PARA_ID BIGINT PRIMARY KEY IDENTITY(1,1),         -- Clave primaria y autoincremento
    PARA_GRUPO VARCHAR(200) NOT NULL,                  -- Grupo del par�metro
    PARA_ORDEN INT NULL,                     -- Orden del par�metro
    PARA_VALOR VARCHAR(500) NOT NULL,                  -- Valor del par�metro
    PARA_ACTIVO BIT NOT NULL DEFAULT 1,                         -- Indicador de si est� activo (0 o 1)
    PARA_USUARIO_CREACION BIGINT NOT NULL,         -- ID del usuario que crea el registro
    PARA_FECHA_CREACION DATETIME NOT NULL DEFAULT GETDATE(), -- Fecha de creaci�n con valor predeterminado de fecha actual
    PARA_IP_CREACION VARCHAR(20) NOT NULL,            -- IP del usuario que crea el registro
    PARA_USUARIO_MODIFICACION BIGINT NULL,         -- ID del usuario que modifica el registro (puede ser NULL)
    PARA_FECHA_MODIFICACION DATETIME NULL,            -- Fecha de modificaci�n (puede ser NULL)
    PARA_IP_MODIFICACION VARCHAR(20) NULL             -- IP del usuario que modifica el registro (puede ser NULL)
	FOREIGN KEY (PARA_USUARIO_CREACION) REFERENCES SEGURIDAD.USUARIO(USUA_ID),
    FOREIGN KEY (PARA_USUARIO_MODIFICACION) REFERENCES SEGURIDAD.USUARIO(USUA_ID)
);

-- Crear la tabla MAESTRO.CONTINENTE
CREATE TABLE MAESTRO.CONTINENTE (
    CONT_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    CONT_NOMBRE VARCHAR(50) NOT NULL,
    CONT_ACTIVO BIT NOT NULL DEFAULT 1,
    CONT_USUARIO_CREACION BIGINT NOT NULL,
    CONT_FECHA_CREACION DATETIME NOT NULL,
    CONT_IP_CREACION VARCHAR(20) NOT NULL,
    CONT_USUARIO_MODIFICACION BIGINT NULL,
    CONT_FECHA_MODIFICACION DATETIME NULL,
    CONT_IP_MODIFICACION VARCHAR(20) NULL,
    FOREIGN KEY (CONT_USUARIO_CREACION) REFERENCES SEGURIDAD.USUARIO (USUA_ID),
    FOREIGN KEY (CONT_USUARIO_MODIFICACION) REFERENCES SEGURIDAD.USUARIO (USUA_ID)
);
GO

-- Crear la tabla MAESTRO.PAIS
CREATE TABLE MAESTRO.PAIS (
    PAIS_ID BIGINT PRIMARY KEY IDENTITY(1,1),
    PAIS_NOMBRE VARCHAR(100) NOT NULL,
    PAIS_CAPITAL VARCHAR(100) NOT NULL,
    PAIS_CONTINENTE_ID BIGINT NOT NULL,
    PAIS_NACIONALIDAD VARCHAR(50),
    PAIS_ACTIVO BIT NOT NULL DEFAULT 1,
    PAIS_USUARIO_CREACION BIGINT NOT NULL,
    PAIS_FECHA_CREACION DATETIME NOT NULL,
    PAIS_IP_CREACION VARCHAR(20) NOT NULL,
    PAIS_USUARIO_MODIFICACION BIGINT NULL,
    PAIS_FECHA_MODIFICACION DATETIME NULL,
    PAIS_IP_MODIFICACION VARCHAR(20) NULL,
    FOREIGN KEY (PAIS_CONTINENTE_ID) REFERENCES MAESTRO.CONTINENTE (CONT_ID),
    FOREIGN KEY (PAIS_USUARIO_CREACION) REFERENCES SEGURIDAD.USUARIO (USUA_ID),
    FOREIGN KEY (PAIS_USUARIO_MODIFICACION) REFERENCES SEGURIDAD.USUARIO (USUA_ID)
);
GO

INSERT INTO MAESTRO.CONTINENTE (CONT_NOMBRE,CONT_USUARIO_CREACION,CONT_FECHA_CREACION,CONT_IP_CREACION)
VALUES('AFRICA',1,GETDATE(),'0.0.0.0'),
('AMERICA',1,GETDATE(),'0.0.0.0'),
('ASIA',1,GETDATE(),'0.0.0.0'),
('EUROPA',1,GETDATE(),'0.0.0.0'),
('OCEANIA',1,GETDATE(),'0.0.0.0'),
('AMERICA DEL NORTE',1,GETDATE(),'0.0.0.0'),
('AMERICA CENTRAL',1,GETDATE(),'0.0.0.0'),
('AMERICA DEL SUR',1,GETDATE(),'0.0.0.0')

INSERT INTO MAESTRO.PAIS(PAIS_NOMBRE, PAIS_CAPITAL, PAIS_CONTINENTE_ID, PAIS_NACIONALIDAD,
						 PAIS_USUARIO_CREACION, PAIS_FECHA_CREACION, PAIS_IP_CREACION)
VALUES('PERU','LIMA',(SELECT CONT_ID FROM MAESTRO.CONTINENTE WHERE CONT_NOMBRE = 'AMERICA DEL SUR'),'PERUANO(A)',1,GETDATE(),'0.0.0.0')


--INSERT INTO MAESTRO.PARAMETRO (	PARA_GRUPO, PARA_ORDEN,PARA_VALOR,
--								PARA_ACTIVO,PARA_USUARIO_CREACION,
--								PARA_FECHA_CREACION,PARA_IP_CREACION)
--SELECT UPPER(Maestro),ISNULL(Orden, 0),UPPER(Detalle),1,1,GETDATE(),'0.0.0.0' FROM DB_SABS.[dbo].[T_MaestroDetalle]


-- INSERTA LOS PREFIJOS PARA LOS CODIGOS DE CAMPA�AS 
INSERT INTO MAESTRO.PARAMETRO(PARA_GRUPO, PARA_ORDEN, PARA_VALOR, PARA_ACTIVO, PARA_USUARIO_CREACION, PARA_FECHA_CREACION, PARA_IP_CREACION)
SELECT 'CORRELATIVOS_CAPA�AS',0,Prefijo FROM DB_SABS.[dbo].[T_Correlativos]