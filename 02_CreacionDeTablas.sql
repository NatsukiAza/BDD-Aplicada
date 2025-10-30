CREATE TABLE Administracion(
	 id_Administracion int PRIMARY KEY,
	 nombre varchar(100) NOT NULL,
	correo_electronico varchar(20) NOT NULL
)

CREATE TABLE Consorcio(
	id_Consorcio int PRIMARY KEY,
	id_administracion int FOREIGN KEY References  Administracion(id_Administracion) ON DELETE CASCADE,
	Nombre varchar(20) NOT NULL,
	Direccion varchar(20) NOT NULL,
	Superficie DECIMAL(10,2) NOT NULL
)

CREATE TABLE unidad_Funcional(
	ID_UF int PRIMARY KEY,
	ID_Consorcio int FOREIGN KEY references Consorcio(id_Consorcio) ON DELETE CASCADE,
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
    REFERENCES Persona(tipo_documento, numero_documento) ON DELETE CASCADE,
	CONSTRAINT FK_Relacion_UF FOREIGN KEY (ID_UF)
    REFERENCES Unidad_Funcional(ID_UF) ON DELETE CASCADE

)
	
CREATE TABLE Expensa (
    ID_Expensa INT PRIMARY KEY,
    ID_Consorcio INT NOT NULL,
    Fecha_Generada DATE NOT NULL,
    Fecha_Venc1 DATE NOT NULL,
    Fecha_Venc2 DATE NOT NULL CHECK (Fecha_Venc2 > Fecha_Venc1),
    Expensas_Ord DECIMAL(12,2) CHECK (Expensas_Ord >= 0),
    Expensas_Extraord DECIMAL(12,2) CHECK (Expensas_Extraord >= 0),
    Total_Expensa as (Expensas_Ord + Expensas_Extraord),
    Estado VARCHAR(15) CHECK (Estado IN ('GENERADA','ENVIADA','PAGADA','VENCIDA')),

    CONSTRAINT FK_Expensa_Consorcio FOREIGN KEY (ID_Consorcio)
        REFERENCES Consorcio(ID_Consorcio)
        ON DELETE CASCADE
)

CREATE TABLE Gasto (
    ID_Gasto INT PRIMARY KEY,
    ID_Expensa INT NOT NULL,
    Tipo_Gasto NVARCHAR(50) NOT NULL,
    Fecha DATE NOT NULL,
    Monto DECIMAL(12,2) CHECK (Monto >= 0),
    Detalle NVARCHAR(255),

    CONSTRAINT FK_Gasto_Expensa FOREIGN KEY (ID_Expensa)
        REFERENCES Expensa(ID_Expensa)
        ON DELETE CASCADE
)

CREATE TABLE Detalle_Expensa (
    ID_Detalle INT PRIMARY KEY,
    ID_Expensa INT NOT NULL,
    ID_UF INT NOT NULL,
    Pagos_Recibidos DECIMAL(12,2) DEFAULT 0 CHECK (Pagos_Recibidos >= 0),
    Deuda DECIMAL(12,2) DEFAULT 0 CHECK (Deuda >= 0),
    Interes_Mora DECIMAL(12,2) DEFAULT 0 CHECK (Interes_Mora >= 0),
    Detalle_Ordinarias DECIMAL(12,2) CHECK (Detalle_Ordinarias >= 0),
    Detalle_Extraord DECIMAL(12,2) CHECK (Detalle_Extraord >= 0),
    Total DECIMAL(12,2) CHECK (Total >= 0),

    CONSTRAINT FK_Detalle_Expensa FOREIGN KEY (ID_Expensa)
        REFERENCES Expensa(ID_Expensa)
        ON DELETE CASCADE,

    CONSTRAINT FK_Detalle_UF FOREIGN KEY (ID_UF)
        REFERENCES unidad_Funcional(ID_UF)
        ON DELETE CASCADE
)

CREATE TABLE Pago (
    ID_Pago INT PRIMARY KEY,
    ID_Detalle INT NOT NULL,
    Fecha_Pago DATE NOT NULL,
    Cuenta_Origen VARCHAR(30) NOT NULL,
    Importe DECIMAL(12,2) CHECK (Importe >= 0),
    Estado VARCHAR(15) CHECK (Estado IN ('PENDIENTE','CONFIRMADO','ANULADO')),
    Detalle NVARCHAR(255),
    Tipo_Pago VARCHAR(15) CHECK (Tipo_Pago IN ('ORDINARIO','EXTRAORDINARIO')),

    CONSTRAINT FK_Pago_Detalle FOREIGN KEY (ID_Detalle)
        REFERENCES Detalle_Expensa(ID_Detalle)
        ON DELETE CASCADE
)
