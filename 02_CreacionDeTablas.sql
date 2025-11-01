USE COM025600;

CREATE TABLE Administracion(
	 ID_Administracion INT PRIMARY KEY,
	 Nombre VARCHAR(100) NOT NULL,
	Correo_Electronico VARCHAR(100) NOT NULL
)

CREATE TABLE Consorcio(
	ID_Consorcio INT PRIMARY KEY,
	ID_Administracion INT FOREIGN KEY References  Administracion(ID_Administracion) ON DELETE CASCADE,
	Nombre VARCHAR(100) NOT NULL,
	Direccion VARCHAR(100) NOT NULL,
	Superficie DECIMAL(10,2) NOT NULL
)

CREATE TABLE Unidad_Funcional(
	ID_UF INT PRIMARY KEY,
	ID_Consorcio INT FOREIGN KEY references Consorcio(ID_Consorcio) ON DELETE CASCADE,
	Piso CHAR(2) NOT NULL, check (Piso = 'PB' or (TRY_CAST(Piso as INT) between 0 and 20)),
	Departamento CHAR(1) NOT NULL,
	Superficie_m2 DECIMAL(10,2) NOT NULL,check (Superficie_m2>10),
	Porcentaje_Prorrateo DECIMAL(10,2) NOT NULL, check( Porcentaje_Prorrateo >=0 and Porcentaje_Prorrateo <= 100),
	Tiene_Cochera CHAR(2) NOT NULL, check (Tiene_Cochera in ('SI','NO')),
	Tiene_Bahulera CHAR(2) NOT NULL, check (Tiene_Bahulera in ('SI','NO'))
)

CREATE TABLE Persona(
	Tipo_Documento TINYINT,
	Numero_documento INT,
	Nombre VARCHAR(100) NOT NULL,
	Apellido VARCHAR(100) NOT NULL,
	Correo_Electronico VARCHAR(100) NOT NULL,
	Telefono INT NOT NULL CHECK(Telefono between 1100000000 and 1200000000),
	PRIMARY KEY(Tipo_Documento,Numero_documento)
)

CREATE TABLE Relacion_UF_Persona(
	ID_Relacion INT Primary key,
	ID_UF INT,
	Tipo_Documento TINYINT,
	Num_Documento INT,
	Fecha_Inicio DATE NOT NULL,
	Fecha_Fin DATE NOT NULL, CHECK(Fecha_Fin > Fecha_Inicio),
	Rol VARCHAR(11) NOT NULL CHECK (Rol IN ('PROPIETARIO','INQUILINO')),
	CBU_CVU_Pago CHAR(22) NOT NULL,
	CONSTRAINT FK_Relacion_Persona FOREIGN KEY (Tipo_Documento, Num_Documento)
    REFERENCES Persona(Tipo_Documento, Numero_documento) ON DELETE CASCADE,
	CONSTRAINT FK_Relacion_UF FOREIGN KEY (ID_UF)
    REFERENCES Unidad_Funcional(ID_UF) ON DELETE CASCADE
)
