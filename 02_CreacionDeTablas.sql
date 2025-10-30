CREATE TABLE Administracion(
	 id_Administracion int PRIMARY KEY,
	 nombre varchar(100) NOT NULL,
	correo_electronico varchar(20) NOT NULL
)

CREATE TABLE Consorcio(
	id_Consorcio int PRIMARY KEY,
	id_administracion int FOREIGN KEY References  Administracion(id_Administracion),
	Nombre varchar(20) NOT NULL,
	Direccion varchar(20) NOT NULL,
	Superficie DECIMAL(10,2) NOT NULL
)

CREATE TABLE unidad_Funcional(
	ID_UF int PRIMARY KEY,
	ID_Consorcio int FOREIGN KEY references Consorcio(id_Consorcio),
	piso char(2) NOT NULL, check (piso = 'PB' or (TRY_CAST(piso as INT) between 0 and 20)),
	departamento CHAR(1) NOT NULL,
	Superficie_m2 DECIMAL(10,2) NOT NULL,check (Superficie_m2>10),
	porcentaje_prorrateo DECIMAL(10,2) NOT NULL, check( porcentaje_prorrateo >=0 and porcentaje_prorrateo <= 100),
	tiene_cochera CHAR(2) NOT NULL, check (tiene_cochera in ('SI','NO')),
	tiene_bahulera CHAR(2) NOT NULL, check (tiene_bahulera in ('SI','NO'))
)

CREATE TABLE Persona(
	tipo_documento int,
	numero_documento int,
	nombre varchar(20) NOT NULL,
	apellido varchar(20) NOT NULL,
	correo_electronico varchar(35) NOT NULL,
	Telefono int NOT NULL CHECK(Telefono between 1100000000 and 1200000000),
	PRIMARY KEY(tipo_documento,numero_documento)
)

CREATE TABLE Relacion_UF_Persona(
	id_relacion int Primary key,
	ID_UF int,
	tipo_documento int,
	num_documento int,
	fecha_inicio DATE NOT NULL,
	fecha_fin DATE NOT NULL, check(fecha_fin > fecha_inicio),
	rol varchar(20) NOT NULL,
	CBU_CVU_Pago char(22) NOT NULL,
	CONSTRAINT FK_Relacion_Persona FOREIGN KEY (tipo_documento, num_documento)
    REFERENCES Persona(tipo_documento, numero_documento),
	CONSTRAINT FK_Relacion_UF FOREIGN KEY (ID_UF)
    REFERENCES Unidad_Funcional(ID_UF)
)