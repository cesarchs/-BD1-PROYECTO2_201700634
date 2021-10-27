
#CONSULTA #1
/*
Desplegar para cada elección el país y el partido político que obtuvo mayor
porcentaje de votos en su país. Debe desplegar el nombre de la elección, el
año de la elección, el país, el nombre del partido político y el porcentaje que
obtuvo de votos en su país.
*/
USE BASES1P2;


SELECT PAIS.PAIS,municipio, PARTIDO.PARTIDO, PARTIDO.NOMBRE_PARTIDO, SUM(POBLACION.ANALFABETO) AS VOTOS
FROM PAIS, 
	 REGION, 
     DEPTO, 
     MUNICIPIO, 
     PARTIDO,
     MUNICIPIO_PARTIDO,
     POBLACION 
WHERE  	 # UNIMOS PAIS, REGION, DEPTO Y MUNI
		 PAIS.ID_PAIS = REGION.FK_ID_PAIS
     AND REGION.ID_REGION = DEPTO.FK_ID_REGION
     AND DEPTO.ID_DEPTO = MUNICIPIO.FK_ID_DEPTO
     
		# UNIMOS PARTIDO CON MUNICIPIO
	and municipio_partido.fk_id_municipio = municipio.id_municipio
    and municipio_partido.fk_id_partido = partido.id_partido
     
		# UNIMOS POBLACION 
	 AND POBLACION.FK_ID_MUNICIPIO = MUNICIPIO.ID_MUNICIPIO
     
     group by PARTIDO
 ;




select * from municipio_partido
order by fk_id_partido

;

SELECT MUNICIPIO.MUNICIPIO, ID_POBLACION, PARTIDO.NOMBRE_PARTIDO
FROM  MUNICIPIO, POBLACION, PARTIDO, MUNICIPIO_PARTIDO
WHERE  # UNIMOS PAIS, REGION, DEPTO Y MUNI
		# PAIS.ID_PAIS = REGION.FK_ID_PAIS
     #AND REGION.ID_REGION = DEPTO.FK_ID_REGION
     #AND DEPTO.ID_DEPTO = MUNICIPIO.FK_ID_DEPTO
	   # UNIMOS POBLACION 
	  POBLACION.FK_ID_MUNICIPIO = MUNICIPIO.ID_MUNICIPIO
	 AND MUNICIPIO_PARTIDO.FK_ID_MUNICIPIO = MUNICIPIO.ID_MUNICIPIO
     AND MUNICIPIO_PARTIDO.FK_ID_PARTIDO = PARTIDO.ID_PARTIDO


















# PAIS CON LOS PARTIDOS POR PAIS
select pais , partido.partido , partido.nombre_partido
from partido, pais, region, depto, municipio, municipio_partido
WHERE pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
    and municipio.fk_id_depto = depto.id_depto
    and municipio_partido.fk_id_municipio = municipio.id_municipio
    and municipio_partido.fk_id_partido = partido.id_partido
group by partido
;

# pais, region, depto, muni y su poblacion
select pais, region, depto, municipio, id_poblacion
from pais, region, depto, municipio, poblacion
where pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
    and poblacion.fk_id_municipio = municipio.id_municipio
;


# votos por municipio
select pais, region, depto, municipio, id_poblacion, sum(poblacion.analfabeto + poblacion.alfabeto) as votos
from pais, region, depto, municipio, poblacion
where pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
    and poblacion.fk_id_municipio = municipio.id_municipio
   # AND municipio.municipio = 'Sensuntepeque'
    group by  municipio
;






# pais con cantidad de votos por pais
select eleccion.nombre_eleccion, eleccion.anio_eleccion , pais, sum(poblacion.analfabeto + poblacion.alfabeto) as votos
from pais, region, depto, municipio, poblacion, eleccion, municipio_eleccion #, partido, partido_eleccion, municipio_partido, poblacion_eleccion
where pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
    and poblacion.fk_id_municipio = municipio.id_municipio
    #eleccion 
    and municipio_eleccion.fk_id_municipio = municipio.id_municipio
    and municipio_eleccion.fk_id_eleccion = eleccion.id_eleccion
    # partido 
    #and partido_eleccion.fk_id_eleccion = eleccion.id_eleccion
    #and partido_eleccion.fk_id_partido = partido.id_partido
   # and municipio_partido.fk_id_municipio = municipio.id_municipio
   # and municipio_partido.fk_id_partido = partido.id_partido
    # poblacion eleccion
   # and poblacion_eleccion.fk_id_poblacion = poblacion.id_poblacion
   # and poblacion_eleccion.fk_id_eleccion = eleccion.id_eleccion
group by pais
;




#votos por partido
select partido.nombre_partido
from partido;





select PA AS PAISS, PO AS poblacion, max(suma) as maximo
FROM
(
SELECT  pais.pais AS PA, poblacion.id_poblacion AS PO, sum(poblacion.analfabeto + poblacion.alfabeto) as suma 
FROM  pais, region, depto, municipio, poblacion
WHERE pais.id_pais = region.fk_id_pais
	AND region.id_region = depto.fk_id_region
    AND depto.id_depto = municipio.fk_id_depto
    AND poblacion.fk_id_municipio = municipio.id_municipio
group by poblacion.id_poblacion
order by suma desc
) as tableD
group by PAISS



LIMIT 1
;




# MUNICIPIOS POR PAIS 
SELECT PAIS.pais, MUNICIPIO.MUNICIPIO
FROM PAIS, region , depto, municipio
WHERE pais.id_pais = region.fk_id_pais
	AND region.id_region = depto.fk_id_region
    AND depto.id_depto = municipio.fk_id_depto
    AND PAIS.PAIS = 'EL SALVADOR'
ORDER BY MUNICIPIO;



# CANTIDAD DE REGIONES POR PAIS
Select count(*)
from pais, region
where PAIS.ID_PAIS = REGION.FK_ID_PAIS
AND PAIS = 'EL SALVADOR'
UNION 
(
Select count(*)
from pais, region
where PAIS.ID_PAIS = REGION.FK_ID_PAIS
AND PAIS = 'GUATEMALA'
)
UNION 
Select count(*)
from pais, region
where PAIS.ID_PAIS = REGION.FK_ID_PAIS
AND PAIS = 'nicaragua'

;


USE BASES1P2;