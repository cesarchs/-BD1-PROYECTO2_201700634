USE BASES1P2;
##################################################################################################################################################
#CONSULTA #1
/*
Desplegar para cada elección el país y el partido político que obtuvo mayor
porcentaje de votos en su país. Debe desplegar el nombre de la elección, el
año de la elección, el país, el nombre del partido político y el porcentaje que
obtuvo de votos en su país.
*/

SELECT nomb_ele as NOMBRE_ELECCION, anio_ele AS AÑO_ELECCION , paiss AS PAIS, par_nomb AS NOMBRE_PARTIDO, suma*100/total AS PORCENTAJE
FROM (
SELECT pais.pais as paiss, eleccion.nombre_eleccion as nomb_ele, eleccion.anio_eleccion AS anio_ele, partido.nombre_partido as par_nomb, partido.partido as part_part , sum(poblacion.alfabeto + poblacion.analfabeto) as suma
FROM pais, region, depto, municipio,
	poblacion,
    eleccion, municipio_eleccion,
    partido, municipio_partido
where 	#pais hasta municipio
		pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and depto.id_depto = municipio.fk_id_depto
    # poblacion
    and poblacion.fk_id_municipio = municipio.id_municipio
    # eleccion, municipio eleccion
    and municipio_eleccion.fk_id_municipio = municipio.id_municipio
    and municipio_eleccion.fk_id_eleccion = eleccion.id_eleccion
    # partido, municipio partido
    and municipio_partido.fk_id_municipio = municipio.id_municipio
    and municipio_partido.fk_id_partido = partido.id_partido
    and partido.id_partido = poblacion.fk_id_partido
group by  partido.nombre_partido
order by  suma desc
) a ,(
SELECT pais.pais as paisss, sum(poblacion.alfabeto + poblacion.analfabeto) as total
FROM pais, region, depto, municipio,
	poblacion,
    eleccion, municipio_eleccion,
    partido, municipio_partido
where 	#pais hasta municipio
		pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and depto.id_depto = municipio.fk_id_depto
    # poblacion
    and poblacion.fk_id_municipio = municipio.id_municipio
    # eleccion, municipio eleccion
    and municipio_eleccion.fk_id_municipio = municipio.id_municipio
    and municipio_eleccion.fk_id_eleccion = eleccion.id_eleccion
    # partido, municipio partido
    and municipio_partido.fk_id_municipio = municipio.id_municipio
    and municipio_partido.fk_id_partido = partido.id_partido
    and partido.id_partido = poblacion.fk_id_partido
group by  pais.pais) b
where b.paisss = a.paiss
group by  paiss
order by par_nomb
;


###################################################################################################################################################################
#CONSULTA # 2
/*
Desplegar total de votos y porcentaje de votos de mujeres por departamento
y país. El ciento por ciento es el total de votos de mujeres por país. (Tip:
Todos los porcentajes por departamento de un país deben sumar el 100%)
*/

SELECT paiss AS PAIS , deptoo AS DEPARTAMENTO , votos as TOTAL_VOTOS , (votos*100/total) AS PORCENTAJE
FROM (
		select pais as paiss, region as regionn, depto as deptoo, sexo.sexo as sexoo, sum(poblacion.alfabeto + poblacion.analfabeto) as votos
		from pais, region, depto, municipio,
			 poblacion,
			 sexo, detalle_sexo
		where 	#comprobacion desde pais hasta municipio 
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
			
				# POBLACION 
			and poblacion.fk_id_municipio = municipio.id_municipio
				
				# SEXO Y DETALLE SEXO
			and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
			and detalle_sexo.fk_id_sexo = sexo.id_sexo
			and sexo.sexo = 'mujeres'
			group by depto.depto
			order by id_poblacion
    ) a,
	(
		select pais as paisss, sum(poblacion.alfabeto + poblacion.analfabeto) as total
		from pais, region, depto, municipio,
			 poblacion,
			 sexo, detalle_sexo
		where 	#comprobacion desde pais hasta municipio 
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
			
				# POBLACION 
			and poblacion.fk_id_municipio = municipio.id_municipio
				
				# SEXO Y DETALLE SEXO
			and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
			and detalle_sexo.fk_id_sexo = sexo.id_sexo
			and sexo.sexo = 'mujeres'
			group by pais.pais
	) b
    where a.paiss = b.paisss
;

#####################################################################################################################################################################
# CONSULTA # 3 
/*
	Desplegar el nombre del país, nombre del partido político y número de
	alcaldías de los partidos políticos que ganaron más alcaldías por país.
*/
# varias al del aux
select pas as pais, par as partido, veces
FROM
(
		SELECT PAIS as pas, PARTIDO as par, COUNT(MUNICIPIO) AS VECES 
		FROM
		(
				SELECT PA AS PAIS, MUNI AS MUNICIPIO, PARTI AS PARTIDO, VOTOS
				FROM
				(
						SELECT pais AS PA, municipio AS MUNI, partido.nombre_partido AS PARTI, sum(poblacion.analfabeto + poblacion.alfabeto) as votos
						FROM 	PARTIDO, MUNICIPIO_PARTIDO,
								PAIS, REGION, DEPTO, MUNICIPIO,
								poblacion
						WHERE
								# PAIS - MUNICIPIO 
								pais.id_pais = region.fk_id_pais
							and region.id_region = depto.fk_id_region
							and municipio.fk_id_depto = depto.id_depto
								# PARTIDO
							and municipio_partido.fk_id_municipio = municipio.id_municipio
							and municipio_partido.fk_id_partido = partido.id_partido
								# POBLACION
							and poblacion.fk_id_municipio = municipio.id_municipio
							and poblacion.fk_id_partido = partido.id_partido    

						group by municipio, partido.nombre_partido
						order by municipio, votos desc
				) a
				group by MUNI 
		) b
		#where pais = 'HONDURAS'
		group by PAIS, PARTIDO
        order by veces desc
)c
group by pas
;


##########################################################################################################################################################################################################

#CONSULTA # 4
 /*
	Desplegar todas las regiones por país en las que predomina la raza indígena.
	Es decir, hay más votos que las otras razas.
 */
 
select pa as pais, re as region, ra as raza, votos
FROM 
(
	SELECT PAIS.PAIS as pa, REGION.REGION as re , RAZA.RAZA as ra, sum(poblacion.alfabeto + poblacion.analfabeto) as votos
	FROM pais, region, depto, municipio,
			poblacion,
			raza, detalle_raza 

	WHERE 	# PAIS - MUNICIPIO 
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto

			# POBLACION 
		and poblacion.fk_id_municipio = municipio.id_municipio
		
			# RAZA Y DETALLE REAZA
		and detalle_raza.fk_id_poblacion = poblacion.id_poblacion
		and detalle_raza.fk_id_raza = raza.id_raza
		
		group by pais.pais, region.region, raza.raza
		order by votos desc
) a
	# QUE SEA SOLO RAZA INDIGENA	
where ra = 'INDIGENAS'
group by pa, re
order by pa
;

##########################################################################################################################################################################################################
# CONSULTA # 5
 /*
	Desplegar el nombre del país, el departamento, el municipio y la cantidad de
	votos universitarios de todos aquellos municipios en donde la cantidad de
	votos de universitarios sea mayor que el 25% de votos de primaria y menor
	que el 30% de votos de nivel medio. Ordene sus resultados de mayor a
	menor.
 */
 
SELECT pa1 as PAIS, dep1 AS DEPARTAMENTO, mun1 AS MUNICIPIO ,  votosu1 AS VOTOS_UNIVERSITARIOS
FROM 
(	
    SELECT pais.pais as pa1 , depto.depto as dep1 ,  municipio.municipio as mun1, sum(poblacion.universitario) as votosu1
    FROM pais, region, depto , municipio,
			poblacion 
	WHERE	# PAIS - MUNICIPIO 
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
        
			# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
	group by municipio

) a
,
(
# PRIMARIA 
    SELECT pais.pais as pa2 , depto.depto as dep2 ,  municipio.municipio as mun2, sum(poblacion.primaria)*0.25 as votosu2
    FROM pais, region, depto , municipio,
			poblacion 
	WHERE	# PAIS - MUNICIPIO 
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
        
			# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
	group by municipio

) b
,
(
# NIVEL MEDIO
    SELECT pais.pais as pa3 , depto.depto as dep3 ,  municipio.municipio as mun3, sum(poblacion.nivel_medio)*0.30 as votosu3
    FROM pais, region, depto , municipio,
			poblacion 
	WHERE	# PAIS - MUNICIPIO 
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
        
			# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
	group by municipio
) c
WHERE 		# IGUALAR PAIS
			a.pa1 = b.pa2
        and a.pa1 = c.pa3
        and c.pa3 = b.pa2
			
            # IGUALAR DEPARTAMENTO 
        and a.dep1 = b.dep2
        and a.dep1 = c.dep3
        and b.dep2 = c.dep3
        
			# IGUALAR MUNICIPIO
		and a.mun1 = b.mun2
        and a.mun1 = c.mun3
        and b.mun2 = c.mun3
        
			# CONDICIONES 
		and votosu1 > votosu2
        and votosu1 < votosu3
	
order by VOTOS_UNIVERSITARIOS DESC
;
##########################################################################################################################################################################################################
# CONSULTA # 6
/*
	Desplegar el porcentaje de mujeres universitarias y hombres universitarios
	que votaron por departamento, donde las mujeres universitarias que votaron
	fueron más que los hombres universitarios que votaron.
*/
SELECT PAIS, REGION, DEPARTAMENTO, MUJERES, HOMBRES, CONCAT((MUJERES*100/TotalVotos),' %') as PORCENTAJE_M , CONCAT((HOMBRES*100/TotalVotos),' %') as PORCENTAJE_H
FROM 
(
	select pais.pais AS pa3 , region.region as re3 , depto.depto as dep3 , sum(poblacion.analfabeto + poblacion.alfabeto) as TotalVotos
	from pais, region, depto, municipio, poblacion
	where 	# pais hasta municipio 
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
			# poblacion 
		and poblacion.fk_id_municipio = municipio.id_municipio
		group by  depto
) c
,
(
	SELECT pa1 as PAIS, re1 as REGION, dep1 as DEPARTAMENTO , votos1 AS MUJERES , votos2 AS HOMBRES
	FROM 
	(
		SELECT PAIS.PAIS as pa1 , region.region as re1 , DEPTO.DEPTO as dep1 , SEXO.SEXO as sex1,sum(poblacion.universitario) as votos1
		FROM PAIS, REGION, DEPTO, MUNICIPIO,
				POBLACION,
				SEXO, DETALLE_SEXO
		WHERE 		# PAIS - MUNICIPIO 
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
			
					# POBLACION
			and poblacion.fk_id_municipio = municipio.id_municipio
			
					# SEXO
			and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
			and detalle_sexo.fk_id_sexo = sexo.id_sexo
					
					# CONDICION
			and sexo.sexo = 'mujeres'
		GROUP BY depto.depto, sexo.sexo
	) a
	,
	(
		SELECT PAIS.PAIS as pa2 , region.region as re2 , DEPTO.DEPTO as dep2 , SEXO.SEXO as sex2 , sum(poblacion.universitario) as votos2
		FROM PAIS, REGION, DEPTO, MUNICIPIO,
				POBLACION,
				SEXO, DETALLE_SEXO
		WHERE 		# PAIS - MUNICIPIO 
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
			
					# POBLACION
			and poblacion.fk_id_municipio = municipio.id_municipio
			
					# SEXO
			and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
			and detalle_sexo.fk_id_sexo = sexo.id_sexo
					
					# CONDICION
			and sexo.sexo = 'hombres'
		GROUP BY depto.depto, sexo.sexo
	) b

	WHERE  		# IGUALACION DE POSICION DE TUPLAS
				a.pa1 = b.pa2
			and a.re1 = b.re2
			and a.dep1 = b.dep2
			
				# CONDICION 
			and a.votos1 > b.votos2
) d
WHERE 	# IGUALAMOS LAS TUPLAS 
		c.pa3 = d.pais
    and c.re3 = d.REGION
    and c.dep3 = d.DEPARTAMENTO
;
##########################################################################################################################################################################################################
# CONSULTA # 7 
/*
	Desplegar el nombre del país, la región y el promedio de votos por
	departamento. Por ejemplo: si la región tiene tres departamentos, se debe
	sumar todos los votos de la región y dividirlo dentro de tres (número de
	departamentos de la región).
*/
SELECT pa1 as PAIS, re1 as REGION , (TOTAL_VOTOS/CANTIDAD_DEPARTAMENTOS) as PROMEDIO
FROM 
(
	select pais.pais as pa1 , region.region as re1 , sum(poblacion.analfabeto + poblacion.alfabeto) AS TOTAL_VOTOS
	from pais, region, depto, municipio,
			poblacion
	where 		# desde pais hasta municipio
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
				# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
	group by pais.pais, region.region
) a
,
(
	# CUANTOS DEPARTAMENTOS QUE TIENE CADA PAIS POR REGION 
	select pais.pais as pa2 , region.region as re2 , COUNT(depto) AS CANTIDAD_DEPARTAMENTOS
	from pais, region, depto
	where 		# desde pais hasta municipio
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		
		group by pais.pais, region.region
) b
where 
		# IGUALAMOS LAS VARIABLES, PARA IGUALAR LAS POSICIONES DE TUPLAS
			a.pa1 = b.pa2
        and a.re1 = b.re2

;

##########################################################################################################################################################################################################
# CONSULTA # 8 
/*
	Desplegar el total de votos de cada nivel de escolaridad (primario, medio,
	universitario) por país, sin importar raza o sexo.
*/
select pais, sum(poblacion.primaria) as PRIMARIA , sum(poblacion.nivel_medio) as NIVEL_MEDIO , sum(poblacion.universitario) as UNIVERSITARIOS
from pais, region, depto, municipio,
		poblacion
where 		# PAIS A MUNICIPIO 
		pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
			# POBLACION
    and poblacion.fk_id_municipio = municipio.id_municipio
group by PAIS.PAIS
;
##########################################################################################################################################################################################################
# CONSULTA # 9 
/*
	Desplegar el nombre del país y el porcentaje de votos por raza.
*/
SELECT pa1 as PAIS , ra1 as RAZA , (SUM_RAZA*100/total_votos) as PORCENTAJE
FROM
(
	SELECT PAIS.PAIS AS pa1 , RAZA.RAZA as ra1, SUM(POBLACION.ANALFABETO + POBLACION.ALFABETO) AS SUM_RAZA
	FROM PAIS, REGION, DEPTO, MUNICIPIO,
			POBLACION,
			RAZA, DETALLE_RAZA
	WHERE 		# PAIS A MUNICIPIO 
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
				
				# POBLACION 
		and poblacion.fk_id_municipio = municipio.id_municipio
		
				# RAZA , DETALLE_RAZA
		and detalle_raza.fk_id_poblacion = poblacion.id_poblacion
		and detalle_raza.fk_id_raza = raza.id_raza
		
	group by PAIS.PAIS, RAZA.RAZA
 ) a
,
(
	select  pais as pa2 , sum(poblacion.analfabeto + poblacion.alfabeto) as total_votos
	from pais, region, depto, municipio, poblacion 
	where 		# PAIS A MUNI
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
				# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
	group by pais
) b
WHERE 
		# IGUALACION DE PAIS, PARA IGUALAR VALORES EN TUPLAS
        a.pa1 = b.pa2
;
##########################################################################################################################################################################################################
# CONSULTA # 10
/*
	Desplegar el nombre del país en el cual las elecciones han sido más
	peleadas. Para determinar esto se debe calcular la diferencia de porcentajes
	de votos entre el partido que obtuvo más votos y el partido que obtuvo menos
	votos
*/
SELECT PAIS1 as PAIS ,  (DIFERENCIA1 - DIFERENCIA2 ) as DIFERENCIA
FROM 
	(
		SELECT pa1 as PAIS1 ,  (suma_max ) as DIFERENCIA1
		FROM 
			(
			SELECT pais.pais as pa1, partido.nombre_partido as par1, sum(poblacion.alfabeto + poblacion.analfabeto) as suma_max
			FROM pais, region, depto, municipio,
				poblacion,
				partido, municipio_partido
			where 	#pais hasta municipio
					pais.id_pais = region.fk_id_pais
				and region.id_region = depto.fk_id_region
				and depto.id_depto = municipio.fk_id_depto
				# poblacion
				and poblacion.fk_id_municipio = municipio.id_municipio
				# partido, municipio partido
				and municipio_partido.fk_id_municipio = municipio.id_municipio
				and municipio_partido.fk_id_partido = partido.id_partido
				and partido.id_partido = poblacion.fk_id_partido
			group by  partido.nombre_partido
			order by  suma_max desc
			) a
		group by pa1
	) c
    ,
    (
		SELECT pa2 as PAIS2 ,  (suma_min) as DIFERENCIA2
		FROM 
			(
			SELECT pais.pais as pa2, partido.nombre_partido as par2, sum(poblacion.alfabeto + poblacion.analfabeto) as suma_min
			FROM pais, region, depto, municipio,
				poblacion,
				partido, municipio_partido
			where 	#pais hasta municipio
					pais.id_pais = region.fk_id_pais
				and region.id_region = depto.fk_id_region
				and depto.id_depto = municipio.fk_id_depto
				# poblacion
				and poblacion.fk_id_municipio = municipio.id_municipio
				# partido, municipio partido
				and municipio_partido.fk_id_municipio = municipio.id_municipio
				and municipio_partido.fk_id_partido = partido.id_partido
				and partido.id_partido = poblacion.fk_id_partido
			group by  partido.nombre_partido
			order by  suma_min asc
			) b
		group by pa2
	) d
WHERE 	
			# IGUALAR TUPLAS 
		c.PAIS1 = d.PAIS2
ORDER BY DIFERENCIA ASC
LIMIT 1
;
##########################################################################################################################################################################################################
# CONSULTA # 11
/*
	 Desplegar el total de votos y el porcentaje de votos emitidos por mujeres
	indígenas alfabetas
*/
SELECT PA1 AS PAIS, VOTOS_MUJERES_ALFABETAS , (VOTOS_MUJERES_ALFABETAS*100/VOTOS) AS PORCENTAJE
FROM
	(
		SELECT PAIS.PAIS AS PA1 , SUM(POBLACION.ALFABETO ) AS VOTOS_MUJERES_ALFABETAS , RAZA.RAZA, SEXO.SEXO
		FROM PAIS, REGION, DEPTO, MUNICIPIO,
				POBLACION,
				DETALLE_RAZA, RAZA,
				DETALLE_SEXO, SEXO
		WHERE 		# PAIS A MUNI
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
					# POBLACION
			and poblacion.fk_id_municipio = municipio.id_municipio
					# RAZA, DETALLE_RAZA
			and detalle_raza.fk_id_poblacion = poblacion.id_poblacion
			and detalle_raza.fk_id_raza = raza.id_raza
					# SEXO , DETALLE_SEXO
			and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
			and detalle_sexo.fk_id_sexo = sexo.id_sexo
					# CONDICION
			and sexo.sexo = 'mujeres'
			and raza.raza = 'INDIGENAS'
		GROUP BY PAIS.PAIS
	) a
	,
	(
		SELECT PAIS.PAIS AS PA2 , SUM(POBLACION.ALFABETO + POBLACION.ANALFABETO) AS VOTOS 
		FROM PAIS, REGION, DEPTO, MUNICIPIO,
				POBLACION,
				DETALLE_RAZA, RAZA,
				DETALLE_SEXO, SEXO
		WHERE 		# PAIS A MUNI
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
					# POBLACION
			and poblacion.fk_id_municipio = municipio.id_municipio
					# RAZA, DETALLE_RAZA
			and detalle_raza.fk_id_poblacion = poblacion.id_poblacion
			and detalle_raza.fk_id_raza = raza.id_raza
					# SEXO , DETALLE_SEXO
			and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
			and detalle_sexo.fk_id_sexo = sexo.id_sexo
					# CONDICION
		GROUP BY PAIS.PAIS
	) b
WHERE 
		 # IGUALAMOS TUPLAS
	 a.PA1 = b.PA2
;
##########################################################################################################################################################################################################
# CONSULTA # 12 
/*
	Desplegar el nombre del país, el porcentaje de votos de ese país en el que
	han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre
	de país, el de mayor porcentaje).
*/

SELECT pa1 as PAIS, (poblacion_analfabetos*100/votos) AS PORCENTAJE_ANALFABETAS
FROM 
	(
	SELECT pais.pais as pa1, sum(poblacion.analfabeto) as poblacion_analfabetos
	FROM  pais, region, depto, municipio,
			poblacion
	WHERE 		# PAIS A MUNI
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
				# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
	GROUP BY pais.pais
	) a
	,
	(
			# NUMERO TOTAL DE VOTOS POR PAIS
	select  pais.pais as pa2, sum(poblacion.analfabeto + poblacion.alfabeto) as votos
	from pais, region, depto, municipio, poblacion
	where 	
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
		
		and poblacion.fk_id_municipio = municipio.id_municipio
	group by pais
	) b
WHERE
	a.pa1 = b.pa2
ORDER BY PORCENTAJE_ANALFABETAS DESC
LIMIT 1
;
##########################################################################################################################################################################################################
# CONSULTA # 13
/*
	Desplegar la lista de departamentos de Guatemala y número de votos
	obtenidos, para los departamentos que obtuvieron más votos que el
	departamento de Guatemala.
*/

SELECT pa2 as PAIS , dep2 as DEPARTAMENTO, VOTOS_DEPS AS VOTOS_POR_DEPARTAMENTO
FROM
	(
	SELECT pais.pais as pa1 , depto.depto as dep1 , sum(poblacion.analfabeto + poblacion.alfabeto) as VOTOS_DEP_GUATEMALA
	FROM pais, region, depto, municipio,
			poblacion
	WHERE 		# PAIS A MUNI
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
				# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
		
		and depto.depto = 'GUATEMALA'
	GROUP BY pais.pais, depto.depto
	) a
	,
	(
	SELECT pais.pais as pa2 , depto.depto as dep2 , sum(poblacion.analfabeto + poblacion.alfabeto) as VOTOS_DEPS
	FROM pais, region, depto, municipio,
			poblacion
	WHERE 		# PAIS A MUNI
			pais.id_pais = region.fk_id_pais
		and region.id_region = depto.fk_id_region
		and municipio.fk_id_depto = depto.id_depto
				# POBLACION
		and poblacion.fk_id_municipio = municipio.id_municipio
		
	GROUP BY pais, depto.depto
	) b
WHERE 
		# IGUALAR TUPLAS 
		a.pa1 = b.pa2
    and VOTOS_DEPS > VOTOS_DEP_GUATEMALA
;
##########################################################################################################################################################################################################









# PAIS, MUNICIPIO Y PARTIDO Y SUS VOTOS POR MUNICIPIO, SOLO LOS PARTIDOS GANADORES POR MUNICIPIO
SELECT PA AS PAIS, MUNI AS MUNICIPIO, PARTI AS PARTIDO, VOTOS
FROM
(
		SELECT pais AS PA, municipio AS MUNI, partido.nombre_partido AS PARTI, sum(poblacion.analfabeto + poblacion.alfabeto) as votos
		FROM 	PARTIDO, MUNICIPIO_PARTIDO,
				PAIS, REGION, DEPTO, MUNICIPIO,
				poblacion
		WHERE
				# PAIS - MUNICIPIO 
				pais.id_pais = region.fk_id_pais
			and region.id_region = depto.fk_id_region
			and municipio.fk_id_depto = depto.id_depto
				# PARTIDO
			and municipio_partido.fk_id_municipio = municipio.id_municipio
			and municipio_partido.fk_id_partido = partido.id_partido
				# POBLACION
			and poblacion.fk_id_municipio = municipio.id_municipio
			and poblacion.fk_id_partido = partido.id_partido    

		group by municipio, partido.nombre_partido
		order by municipio, votos desc
) a
group by MUNI 
;

# partido politico y sus votos por municipio
SELECT pais, municipio, partido.nombre_partido, sum(poblacion.analfabeto + poblacion.alfabeto) as votos
FROM 	PARTIDO, MUNICIPIO_PARTIDO,
		PAIS, REGION, DEPTO, MUNICIPIO,
        poblacion
WHERE
		# PAIS - MUNICIPIO 
		pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
		# PARTIDO
	and municipio_partido.fk_id_municipio = municipio.id_municipio
    and municipio_partido.fk_id_partido = partido.id_partido
		# POBLACION
	and poblacion.fk_id_municipio = municipio.id_municipio
    and poblacion.fk_id_partido = partido.id_partido    

group by municipio, partido.nombre_partido
order by municipio, votos desc

;

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
group by pais
;


# MUNICIPIOS POR PAIS 
SELECT PAIS.pais, COUNT(DEPTO.DEPTO) CANTIDAD
FROM PAIS, region , depto, municipio
WHERE pais.id_pais = region.fk_id_pais
	AND region.id_region = depto.fk_id_region
    AND depto.id_depto = municipio.fk_id_depto
    AND PAIS.PAIS = 'EL SALVADOR'
ORDER BY DEPTO;

SELECT PAIS.pais, COUNT(MUNICIPIO.MUNICIPIO) CANTIDAD
FROM PAIS, region , depto, municipio
WHERE pais.id_pais = region.fk_id_pais
	AND region.id_region = depto.fk_id_region
    AND depto.id_depto = municipio.fk_id_depto
    AND PAIS.PAIS = 'HONDURAS'
ORDER BY MUNICIPIO;

SELECT PAIS.pais, COUNT(MUNICIPIO.MUNICIPIO) CANTIDAD
FROM PAIS, region , depto, municipio
WHERE pais.id_pais = region.fk_id_pais
	AND region.id_region = depto.fk_id_region
    AND depto.id_depto = municipio.fk_id_depto
    AND PAIS.PAIS = 'GUATEMALA'
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

#PAIS HASTA DEPTO SOLO MUJERES Y LA SUMA DE SUS VOTOS
select pais, region, depto, sexo.sexo, sum(poblacion.alfabeto + poblacion.analfabeto) as votos
from pais, region, depto, municipio,
	 poblacion,
     sexo, detalle_sexo
where 	#comprobacion desde pais hasta municipio 
		pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
    
		# POBLACION 
    and poblacion.fk_id_municipio = municipio.id_municipio
		
        # SEXO Y DETALLE SEXO
	and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
    and detalle_sexo.fk_id_sexo = sexo.id_sexo
    and sexo.sexo = 'mujeres'
    group by depto.depto
    order by id_poblacion
;


# TOTAL DE VOTOS DE MUJERES POR PAIS
select pais, sum(poblacion.alfabeto + poblacion.analfabeto) as total
from pais, region, depto, municipio,
	 poblacion,
     sexo, detalle_sexo
where 	#comprobacion desde pais hasta municipio 
		pais.id_pais = region.fk_id_pais
	and region.id_region = depto.fk_id_region
	and municipio.fk_id_depto = depto.id_depto
    
		# POBLACION 
    and poblacion.fk_id_municipio = municipio.id_municipio
		
        # SEXO Y DETALLE SEXO
	and detalle_sexo.fk_id_poblacion = poblacion.id_poblacion
    and detalle_sexo.fk_id_sexo = sexo.id_sexo
    and sexo.sexo = 'mujeres'
    group by pais.pais
;

# PAIS, REGION Y CANTIDAD DE DEPARTAMENTOS POR REGION EN CADA PAIS
select pais, region, count(depto)
from pais, region, depto
where 
		pais.id_pais = region.fk_id_pais
        and region.id_region = depto.fk_id_region
group by pais, region
;





USE BASES1P2;