# BASES 1 PROYECTO 2.
### PROYECTO 2 DEL CURSO DE BASES DE DATOS 1 SEGUNDO SEMESTRE 2021

DESARROLLADO POR: **CESAR LEONEL CHAMALE SICAN**
CARNET: **201700634**

##
### EN QUE CONSISTE EL PROYECTO ###

El proyecto consiste en la creacion de la base de datos para El Instituto Centroamericano Electoral es una institución dedicada a registrar, controlar y evaluar estadísticas de los comicios electorales en los diferentes países de Centro América.
debemos de crear la base de datos apartir del archivo proporcionado por la entidad, asi como tambien fuimos contratapos para otimizar la base de datos, mediante la implementacion de las formas normales de normalizacion de base de datos.

##
### DESCRIPCION DE LAS REGLAS DE NORMALIZACION APLICADAS ###

#### 1. PRIMERA FORMA DE NORMALIZACION:####
  La primera regla de normalización se expresa generalmente en forma de dos indicaciones separadas.
  
   A. Todos los atributos, valores almacenados en las columnas, deben ser indivisibles. 
   B. No deben existir grupos de valores repetidos.
 
 El valor de una columna debe ser una entidad atómica, indivisible, excluyendo así las dificultades que podría conllevar el tratamiento de un dato formado de varias partes.

#### 2. SEGUNDA FORMA DE NORMALIZACION:####
que no existan dependencias funcionales parciales. Esto significa que todos los valores de las columnas de una fila deben depender de la clave primaria de dicha fila, entendiendo por clave primaria los valores de todas las columnas que la formen, en caso de ser más de una. 

Consiste en que todos los campos de una tabla tengan relación con la llave primaria de una tupla.

#### 3. TERCERA FORMA DE NORMALIZACION:####
Indica que no deben de existir dependencias transitivas entre las columnas de una tabla, lo cual significa que las columnas que no forman parte de la clave primaria deben depender solo de una clave, nunca de otra columna no clave.

##

#### AL ARCHIVO EXCEL SE APLICO HASTA TERCERA FORMA DE NORMALIZACION, EXPLICADA POR CADA TABLA A CONTINUACION. ####

##
~~~
# SEPARAMOS LOS ATRIBUTOS PAIS, REGINO,
# DEPTO Y MUNCIPIO PARA PODER
# OPTIMIZAR EL ESPACION EL LA BASE DE DATOS
# Y DARLE NORMALIZACION, APLICANDO LA 
# PRIMER Y TERCERA FORMA DE 
# NORMALIZACION. DONDE PODEMOS APRECIAR 
# QUE CADA UNO DE ESTAS TABLAS TIENE SUS 
# ATRIBUTOS INDIVISIBLES ASI COMO NO 
# DEPENDIENCIAS PARCIALES EN SUS ATRIBUTOS.
 
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


# SEPARAMOS LOS ATRIBUTOS ELECCION Y PARTIDO
# PARA OPTIMIZAR LA BASE DE DATOS ASI COMO
# TAMBIEN APLICAR LAS REGLAS DE 
# NORMALIZACION A LA BASE DE DATOS
# APLICANDO LA PRIMER, SEGUNDA Y TERCERA 
# FORMA NORMAL, PARA APLICAR CORRECTAMENTE 
# LAS FORMAS DE NORMALIZACION,
# SEPARAMOS LAS TABLAS APLICANDO LA PRIMERA 
# FORMA DE NORMALIZACION DONDE PODERMOS 
# APRECIAR QUE LOS ATRIBUTOS SON INDIVISIBLES
# LUEGO CREAMOS SU RESPECTIVO 
# MASTER DETALLE APLICANDO LA SEGUNDA FORMA
# DE NORMALIZACION
# Y POR ULTIMO PODEMOS APRECIAR QUE NINGUNA 
# TABLA TIENE DEPENDECIAS PARCIALES EN 
# SUS ATRIBUTOS, COMPLETANDO ASI LA TERCER
# FORMA DE NORMALIZACION. 
# DE ESTA MISMA MANERA APLICAMOS LO APLICAMOS 
# PARA LOS ATRIBUTOS DE SEXO Y RAZA.


CREATE TABLE ELECCION(
	id_eleccion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nombre_eleccion varchar(100),
    anio_eleccion int
);

CREATE TABLE PARTIDO (
	id_partido int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	partido varchar(100),
    nombre_partido varchar(100)
);


CREATE TABLE POBLACION (
	id_poblacion int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    primaria 		int,
    nivel_medio 	int,
    universitario 	int,
    analfabeto 		int,
    alfabeto 		int,
	fk_id_municipio int,
    fk_id_eleccion  int,
    fk_id_partido   int,
	FOREIGN KEY (fk_id_municipio) REFERENCES MUNICIPIO (id_municipio),
    FOREIGN KEY (fk_id_eleccion) REFERENCES eleccion (id_eleccion),
    FOREIGN KEY (fk_id_partido) REFERENCES partido (id_partido)
);


CREATE TABLE MUNICIPIO_ELECCION (
	fk_id_municipio 				int,
    fk_id_eleccion 					int,
	descripcion_municipio_eleccion 	varchar(100) default 'desc muni_ele',
	FOREIGN KEY (fk_id_municipio) REFERENCES municipio (id_municipio),
    FOREIGN KEY (fk_id_eleccion) REFERENCES eleccion (id_eleccion),
    PRIMARY KEY (fk_id_municipio, fk_id_eleccion)
);

CREATE TABLE MUNICIPIO_PARTIDO (
	fk_id_municipio 				int,
    fk_id_partido 					int,
	descripcion_municipio_partido 	varchar(100) default 'desc muni_parti',
	FOREIGN KEY (fk_id_municipio) REFERENCES municipio (id_municipio),
    FOREIGN KEY (fk_id_partido) REFERENCES partido (id_partido),
    PRIMARY KEY (fk_id_municipio, fk_id_partido)
);

CREATE TABLE PARTIDO_ELECCION (
	fk_id_partido 					int,
    fk_id_eleccion 					int,
	descripcion_partido_eleccion 	varchar(100) default 'desc part_elec',
    puesto 							varchar(100) default 'p000',
    FOREIGN KEY (fk_id_partido) REFERENCES partido (id_partido),
    FOREIGN KEY (fk_id_eleccion) REFERENCES eleccion (id_eleccion),
    PRIMARY KEY (fk_id_partido, fk_id_eleccion)
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
    FOREIGN KEY (fk_id_raza) REFERENCES raza (id_raza),
    PRIMARY KEY (fk_id_poblacion, fk_id_raza)
);

CREATE TABLE DETALLE_SEXO (
    fk_id_poblacion 			int,
    fk_id_sexo 					int,
	descripcion_detalle_sexo 	varchar(100) default 'desc detalle sexo',
	FOREIGN KEY (fk_id_poblacion) REFERENCES poblacion (id_poblacion),
    FOREIGN KEY (fk_id_sexo) REFERENCES sexo (id_sexo),
    PRIMARY KEY (fk_id_poblacion, fk_id_sexo)
);

~~~
	 

#### ENTIDAD RELACION ####
![ER PROYECTO 2](https://github.com/cesarchs/-BD1-PROYECTO2_201700634/blob/main/ER.JPG)
