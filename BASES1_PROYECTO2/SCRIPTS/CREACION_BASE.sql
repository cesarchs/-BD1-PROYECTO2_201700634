USE BASES1P2;

/*
	ORDEN DE CREACION 
PAIS
REGION
DEPTO
MUNICIPIO
ELECCION
PARTIDO
POBLACION
PARTIDO_ELECCCION
POBLACION_ELECCION
RAZA
SEXO
DETALLE_RAZA
DETALLE_SEXO
*/


drop table POBLACION_ELECCION;
drop table PARTIDO_ELECCCION;
drop table POBLACION;
drop table PARTIDO;
drop table ELECCION;
drop table MUNICIPIO;
drop table DEPTO;
drop table REGION;
drop table pais;




drop table RAZA;
drop table SEXO;
drop table DETALLE_RAZA;
drop table DETALLE_SEXO;

CREATE TABLE PAIS(
	id_pais int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	pais varchar(100)
);


CREATE TABLE REGION(
	id_region int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	region varchar(100),
	fk_id_pais int not null,
	FOREIGN KEY (fk_id_pais) REFERENCES PAIS (id_pais)
);

CREATE TABLE DEPTO(
	id_depto int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	depto varchar(100),
	fk_id_region int not null,
	FOREIGN KEY (fk_id_region) REFERENCES REGION(id_region)
);

CREATE TABLE MUNICIPIO(
	id_municipio int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	municipio varchar(100),
	fk_id_depto int not null,
	FOREIGN KEY (fk_id_depto) REFERENCES DEPTO(id_depto)
);

CREATE TABLE ELECCION(
	id_eleccion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre_eleccion varchar(100),
    anio_eleccion int,
	fk_id_municipio int,
	FOREIGN KEY (fk_id_municipio) REFERENCES MUNICIPIO (id_municipio)
);

CREATE TABLE PARTIDO (
	id_partido int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	partido varchar(100),
    nombre_partido varchar(100),
	fk_id_municipio int,
	FOREIGN KEY (fk_id_municipio) REFERENCES MUNICIPIO (id_municipio)
);

CREATE TABLE POBLACION (
	id_poblacion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    primaria 		int,
    nivel_medio 	int,
    universitario 	int,
    analfabeto 		int,
    alfabeto 		int,
	fk_id_municipio int,
	FOREIGN KEY (fk_id_municipio) REFERENCES MUNICIPIO (id_municipio)
);

CREATE TABLE PARTIDO_ELECCION (
	id_partido_eleccion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_id_eleccion 					int,
    fk_id_partido 					int,
	descripcion_partido_eleccion 	varchar(100) default 'desc part_elec',
    puesto 							varchar(100) default 'p000',
	FOREIGN KEY (fk_id_eleccion) REFERENCES eleccion (id_eleccion),
    FOREIGN KEY (fk_id_partido) REFERENCES partido (id_partido)
);

CREATE TABLE POBLACION_ELECCION (
	id_poblacion_eleccion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fk_id_poblacion 				int,
    fk_id_eleccion 					int,
	descripcion_partido_eleccion 	varchar(100) default 'desc part_elec',
    puesto 							varchar(100) default 'p000',
	FOREIGN KEY (fk_id_poblacion) REFERENCES poblacion (id_poblacion),
    FOREIGN KEY (fk_id_eleccion) REFERENCES eleccion (id_eleccion)
);

CREATE TABLE RAZA (
	id_raza int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	raza varchar(100)
);

CREATE TABLE SEXO (
	id_sexo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	sexo varchar(100)
);

CREATE TABLE DETALLE_RAZA (
    fk_id_poblacion 			int,
    fk_id_raza 					int,
	descripcion_detalle_raza 	varchar(100) default 'desc detalle raza',
	FOREIGN KEY (fk_id_poblacion) REFERENCES poblacion (id_poblacion),
    FOREIGN KEY (fk_id_raza) REFERENCES raza (id_raza)
);

CREATE TABLE DETALLE_SEXO (
    fk_id_poblacion 			int,
    fk_id_sexo 					int,
	descripcion_detalle_sexo 	varchar(100) default 'desc detalle sexo',
	FOREIGN KEY (fk_id_poblacion) REFERENCES poblacion (id_poblacion),
    FOREIGN KEY (fk_id_sexo) REFERENCES sexo (id_sexo)
);
