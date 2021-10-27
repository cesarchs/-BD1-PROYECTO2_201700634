/*
	PAIS
REGION
DEPTO
MUNICIPIO
ELECCION
POBLACION
PARTIDO
MUNICIPIO_ELECCION
MUNICIPIO_PARTIDO
PARTIDO_ELECCCION
POBLACION_ELECCION
RAZA
SEXO
DETALLE_RAZA
DETALLE_SEXO
*/

#--LLENADO DE PAIS-----------------------

INSERT INTO PAIS (pais)
SELECT DISTINCT temporal.PAIS
	FROM temporal;


#--LLENADO DE REGION----------------------

INSERT INTO REGION (region,fk_id_pais)
SELECT DISTINCT t.REGION, p.id_pais
FROM temporal as t, pais as p
where p.pais = t.PAIS;


#--LLENADO DE DEPTO----------------------
INSERT INTO DEPTO (DEPTO,fk_id_region)
SELECT DISTINCT t.DEPTO, r.id_region
FROM temporal as t, region as r, pais as p
where r.region = t.REGION
	AND r.fk_id_pais = p.id_pais
    AND p.pais = t.PAIS
;

#--LLENADO DE MUNICIPIO----------------------
INSERT INTO municipio (MUNICIPIO, fk_id_depto)
SELECT DISTINCT t.MUNICIPIO, d.id_depto
FROM temporal as t, region as r, pais as p, depto as d
where d.depto = t.depto
	AND d.fk_id_region = r.id_region
	AND r.region = t.REGION
	AND r.fk_id_pais = p.id_pais
    AND p.pais = t.PAIS
;


#--LLENADO DE ELECCION ----------------------

INSERT INTO ELECCION (NOMBRE_ELECCION, eleccion.anio_eleccion )
SELECT DISTINCT t.NOMBRE_ELECCION, t.AÑO_ELECCION
FROM temporal as t
;



#--LLENADO DE PARTIDO------------------------------------------------------------

INSERT INTO partido (PARTIDO, NOMBRE_PARTIDO)
SELECT DISTINCT t.PARTIDO, t.NOMBRE_PARTIDO
FROM temporal as t
;


#--LLENADO DE MUNICIPIO_ELECCION----------------------

INSERT INTO MUNICIPIO_ELECCION (fk_id_municipio, fk_id_eleccion)
SELECT DISTINCT 
			m.id_municipio,
            e.id_eleccion
FROM TEMPORAL AS t, MUNICIPIO AS m, ELECCION AS e, pais as p, region as r, depto as d
WHERE 
		p.pais = t.PAIS
    AND r.fk_id_pais = p.id_pais
    AND r.region = t.REGION
    AND d.fk_id_region = r.id_region
    AND d.depto = t.depto
	AND m.fk_id_depto = d.id_depto
	AND t.municipio = m.municipio 
    AND t.nombre_eleccion = e.nombre_eleccion
    AND t.año_eleccion = e.anio_eleccion
;

#--LLENADO DE POBLACION----------------------
INSERT INTO POBLACION (PRIMARIA, NIVEL_MEDIO, UNIVERSITARIO,ANALFABETO, ALFABETO, fk_id_municipio, fk_id_eleccion)
SELECT DISTINCT t.PRIMARIA, t.NIVEL_MEDIO, t.UNIVERSITARIOS, t.ANALFABETOS, t.ALFABETOS, m.id_municipio, e.id_eleccion
FROM temporal as t, region as r, pais as p, depto as d, municipio as m, eleccion as e, municipio_eleccion
where m.municipio = t.MUNICIPIO
	AND m.fk_id_depto = d.id_depto
	AND d.depto = t.depto
	AND d.fk_id_region = r.id_region
	AND r.region = t.REGION
	AND r.fk_id_pais = p.id_pais
    AND p.pais = t.PAIS
    AND municipio_eleccion.fk_id_municipio = m.id_municipio
    AND municipio_eleccion.fk_id_eleccion = e.id_eleccion
;


#--LLENADO DE MUNICIPIO_PARTIDO ----------------------

INSERT INTO MUNICIPIO_PARTIDO (fk_id_municipio, fk_id_partido)
SELECT DISTINCT 
			m.id_municipio,
            p.id_partido
FROM TEMPORAL AS t, MUNICIPIO AS m, partido AS p , pais as a, region as r, depto as d
WHERE 
		a.pais = t.PAIS
    AND r.fk_id_pais = a.id_pais
    AND r.region = t.REGION
    AND d.fk_id_region = r.id_region
    AND d.depto = t.depto
	AND m.fk_id_depto = d.id_depto

	AND t.municipio = m.municipio 
    AND t.partido = p.partido
    AND t.nombre_partido = p.nombre_partido
;


#--LLENADO DE PARTIDO_ELECCCION ----------------------

INSERT INTO PARTIDO_ELECCION (fk_id_eleccion, fk_id_partido)
SELECT DISTINCT 
			e.id_eleccion,
            p.id_partido
FROM TEMPORAL AS t, eleccion AS e, partido AS p , pais as a, region as r, depto as d, municipio as m, municipio_eleccion as me, municipio_partido as mp
WHERE 
		a.pais = t.PAIS
    AND r.fk_id_pais = a.id_pais
    AND r.region = t.REGION
    AND d.fk_id_region = r.id_region
    AND d.depto = t.depto
	AND m.fk_id_depto = d.id_depto
    AND m.municipio = t.municipio
    
	AND me.fk_id_municipio = m.id_municipio
    AND me.fk_id_eleccion = e.id_eleccion
    AND t.nombre_eleccion = e.nombre_eleccion
    AND t.año_eleccion = e.anio_eleccion
    AND mp.fk_id_municipio = m.id_municipio
    AND mp.fk_id_partido = p.id_partido
    AND t.partido = p.partido
    AND t.nombre_partido = p.nombre_partido
;


#--LLENADO DE RAZA ----------------------

INSERT INTO RAZA (RAZA)
SELECT DISTINCT RAZA
	FROM temporal;


#--LLENADO DE SEXO ----------------------

INSERT INTO SEXO (SEXO)
SELECT DISTINCT SEXO
	FROM temporal;


#--LLENADO DE DETALLE_RAZA ----------------------

INSERT INTO DETALLE_RAZA (fk_id_poblacion, fk_id_raza)
SELECT DISTINCT 
			p.id_poblacion,
            ra.id_raza
FROM TEMPORAL AS t, poblacion AS p, raza AS ra, pais as a, region as r, depto as d, MUNICIPIO AS m
WHERE 
		
		a.pais = t.PAIS
    AND r.fk_id_pais = a.id_pais
    AND r.region = t.REGION
    AND d.fk_id_region = r.id_region
    AND d.depto = t.depto
	AND m.fk_id_depto = d.id_depto
	AND m.municipio = t.municipio

	AND p.fk_id_municipio = m.id_municipio
	AND	t.primaria = p.primaria
    AND t.nivel_medio = p.nivel_medio
    AND t.universitarios = p.universitario
    AND t.analfabetos = p.analfabeto
    AND t.alfabetos = p.alfabeto
    AND t.raza = ra.raza
;


#--LLENADO DE DETALLE_SEXO ----------------------


INSERT INTO DETALLE_SEXO (fk_id_poblacion, fk_id_sexo)
SELECT DISTINCT 
			p.id_poblacion,
            s.id_sexo
FROM TEMPORAL AS t, poblacion AS p, sexo AS s, pais as a, region as r, depto as d, MUNICIPIO AS m
WHERE 
		a.pais = t.PAIS
    AND r.fk_id_pais = a.id_pais
    AND r.region = t.REGION
    AND d.fk_id_region = r.id_region
    AND d.depto = t.depto
	AND m.fk_id_depto = d.id_depto
	AND m.municipio = t.municipio

	AND p.fk_id_municipio = m.id_municipio
	AND	t.primaria = p.primaria
    AND t.nivel_medio = p.nivel_medio
    AND t.universitarios = p.universitario
    AND t.analfabetos = p.analfabeto
    AND t.alfabetos = p.alfabeto
    AND t.sexo = s.sexo
;


#----------------------------------------------------------------
# CONTADORES Y MOSTRAR TALBAS 
#----------------------------------------------------------------

	SELECT * FROM PAIS;
	SELECT count(*) FROM PAIS;
#----------------------------------------------------------------

	SELECT * FROM REGION;
	SELECT count(*) FROM REGION;
#----------------------------------------------------------------

	SELECT * FROM DEPTO
	order by fk_id_region;

	SELECT count(*) FROM DEPTO;
#----------------------------------------------------------------

	SELECT * FROM municipio;
	SELECT count(*) FROM municipio;
#----------------------------------------------------------------

	SELECT * FROM POBLACION
	order by fk_id_municipio;
	SELECT count(*) FROM POBLACION;
#----------------------------------------------------------------

	SELECT * FROM ELECCION;
	SELECT count(*) FROM ELECCION;
#----------------------------------------------------------------

	SELECT * FROM partido;
	SELECT count(*) FROM partido;
#----------------------------------------------------------------
	SELECT * FROM MUNICIPIO_ELECCION
	order by fk_id_municipio
	AND fk_id_eleccion;

	SELECT count(*) FROM MUNICIPIO_ELECCION;
#----------------------------------------------------------------
    
	SELECT * FROM MUNICIPIO_PARTIDO
	order by fk_id_partido;

	SELECT count(*) FROM MUNICIPIO_PARTIDO;  
#----------------------------------------------------------------

	SELECT * FROM PARTIDO_ELECCION
	order by fk_id_eleccion;

	SELECT count(*) FROM PARTIDO_ELECCION;
#----------------------------------------------------------------

	SELECT * FROM POBLACION_ELECCION;
	SELECT count(*) FROM POBLACION_ELECCION;
#----------------------------------------------------------------

	SELECT * FROM RAZA;
	SELECT count(*) FROM RAZA;
#----------------------------------------------------------------

	SELECT * FROM SEXO;
	SELECT count(*) FROM SEXO;
#----------------------------------------------------------------

	SELECT * FROM DETALLE_RAZA;
	SELECT count(*) FROM DETALLE_RAZA;
#----------------------------------------------------------------

	SELECT * FROM DETALLE_SEXO;
	SELECT count(*) FROM DETALLE_SEXO;
#----------------------------------------------------------------

	SELECT * FROM TEMPORAL;
	SELECT count(*) FROM TEMPORAL;