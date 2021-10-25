use bases1p2
select count(*) from mytable

drop table prueba
drop table temporal

CREATE TABLE TEMPORAL (
NOMBRE_ELECCION		varchar(100),
AÑO_ELECCION		int,
PAIS				varchar(100),
REGION				varchar(100),
DEPTO				varchar(100),
MUNICIPIO			varchar(100),
PARTIDO				varchar(100),
NOMBRE_PARTIDO		varchar(100),
SEXO				varchar(100),
RAZA				varchar(100),
ANALFABETOS			int,
ALFABETOS			int,
SEXO2				varchar(100),
RAZA2				varchar(100),
PRIMARIA			int,
NIVEL_MEDIO			int,
UNIVERSITARIOS		int
);

set global local_infile=true;
LOAD DATA LOCAL INFILE 'D:\\escritorio\\BASES1_PROYECTO2\\entrada\\ICE-Fuente.csv' INTO TABLE TEMPORAL COLUMNS TERMINATED BY ','LINES TERMINATED BY '\r\n'IGNORE 1 LINES (NOMBRE_ELECCION,AÑO_ELECCION,PAIS,REGION,DEPTO,MUNICIPIO,PARTIDO,NOMBRE_PARTIDO,SEXO,RAZA,ANALFABETOS,ALFABETOS,SEXO,RAZA,PRIMARIA,NIVEL_MEDIO,UNIVERSITARIOS);


select count(*) from temporal;




