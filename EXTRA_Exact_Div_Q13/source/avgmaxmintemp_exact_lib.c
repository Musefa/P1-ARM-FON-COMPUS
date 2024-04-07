/*----------------------------------------------------------------
|   "avgmaxmintemp.c": rutines de càlcul de valors mitjans, màxims
|	i mínims d'una taula de temperatures, expressades en graus
|	Celsius o Fahrenheit, en format Q13 (coma fixa 1:18:13).
|	Implementació cridant rutines aritmètiques libQ13.
| ----------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Abril 2021, Març 2022, Març 2023, Març 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"				/* Q13: tipus Coma Fixa 1:18:13 i 4 ops. aritm. */
#include "CelsiusFahrenheit.h"	/* rutines de conversió C->F i F->C */
#include "avgmaxmintemp.h"		/* mmres: tipus de retorn de màxim i mínim */


/* avgmaxmin_city(): calcula la temperatura mitjana, màxima i mínima d'una
|				ciutat d'una taula de temperatures, amb una fila per ciutat i
|				una columna per mes, expressades en graus Celsius en format
|				Q13.
|	Paràmetres:
|		ttemp[][12]	->	taula de temperatures, amb 12 columnes i nrows files
|		nrows		->	número de files de la taula
|		id_city		->	índex de la fila (ciutat) a processar
|		*mmres		->	adreça de l'estructura t_maxmin que retornarà els
|						resultats de temperatures màximes i mínimes
|	Resultat:	temperatura mitjana, expressada en graus Celsius, en format Q13.
*/		
Q13 avgmaxmin_city(Q13 ttemp[][12], unsigned short nrows, unsigned short id_city, t_maxmin *mmres)
{
	Q13 avg, max, min;
	unsigned short idmin = 0, idmax = 0;	// índexs de temp. mínima i màx.
	unsigned short i;
	Q13 tvar;						// variable temporal de temperatura
	unsigned char overflow;
  
	avg = ttemp[id_city][0];		// inicialitza valors amb primera columna
	max = avg;						// (mes de gener)
	min = avg;
	for (i = 1; i < 12; i++)		// per a la resta de mesos
	{
		tvar = ttemp[id_city][i];			// obtenir temperatura del següent mes
		//avg += tvar;
		avg = add_Q13(avg, tvar, &overflow);	// usar rutina libreria Q13
		if (tvar > max)
		{	max = tvar;						// actualitzar valors resultat
			idmax = i;
		}
		if (tvar < min)
		{
			min = tvar;
			idmin = i;
		}
	}

//	avg /= 12;						// ajustar valor mitjà
	avg = div_Q13(avg, MAKE_Q13(12.0), &overflow);	// usar rutina libreria Q13

	mmres->tmin_C = min;			// transferir mínim-màxim en Celsius
	mmres->tmax_C = max;
									// transferir mínim-màxim en Fahrenheit
	mmres->tmin_F = Celsius2Fahrenheit(min);
	mmres->tmax_F = Celsius2Fahrenheit(max);
									// transferir índexos mínim i màxim
	mmres->id_min = idmin;
	mmres->id_max = idmax;

	return(avg);
}



/* avgmaxmin_month(): calcula la temperatura mitjana, màxima i mínima d'un mes
|				d'una taula de temperatures, amb una fila per ciutat i una
|				columna per mes, expressades en graus Celsius en format Q13.
|	Paràmetres:
|		ttemp[][12]	->	taula de temperatures, amb 12 columnes i nrows files
|		nrows		->	número de files de la taula (mínim 1 fila)
|		id_month	->	índex de la columna (mes) a processar
|		*mmres		->	adreça de l'estructura t_maxmin que retornarà els
|						resultats de temperatures màximes i mínimes
|	Resultat:	temperatura mitjana, expressada en graus Celsius, en format Q13.
*/		
Q13 avgmaxmin_month(Q13 ttemp[][12], unsigned short nrows, unsigned short id_month, t_maxmin *mmres)
{
	Q13 avg, max, min;
	unsigned short idmin = 0, idmax = 0;	// índexos de temp. mínima i màx.
	unsigned short i;
	Q13 tvar;						// variable temporal de temperatura
	unsigned char avgNeg;			// booleà per indicar si mitjana negativa
	unsigned char overflow;
 
	avg = ttemp[0][id_month];		// inicialitza valors amb primera fila
	max = avg;						// (primera ciutat de la taula)
	min = avg;
	i = 1;							// posicionar índex a la segona fila
	while (i < nrows)				// per a la resta de ciutats
	{
		tvar = ttemp[i][id_month];		// obtenir temperatura següent ciutat
		//avg += tvar;
		avg = add_Q13(avg, tvar, &overflow);	// usar rutina libreria Q13
		if (tvar > max)
		{	max = tvar;						// actualitzar valors resultat
			idmax = i;
		}
		if (tvar < min)
		{
			min = tvar;
			idmin = i;
		}
		i++;
	}
	avgNeg = (avg < 0);					// memoritza si valor acumulat negatiu
	tvar = (avgNeg ? -avg : avg); 		// tvar conté valor absolut de avg
//	div_mod(tvar, nrows, (unsigned int *)&avg, &mod);	// calcular valor mitjà sobre avg
	avg = div_Q13(tvar, ((unsigned int)nrows) << 13, &overflow);	// usar rutina libreria Q13
	if (avgNeg) avg = -avg;				// canviar signe de valor mitjà
	
	mmres->tmin_C = min;			// transferir mínim-màxim en Celsius
	mmres->tmax_C = max;
									// transferir mínim-màxim en Fahrenheit
	mmres->tmin_F = Celsius2Fahrenheit(min);
	mmres->tmax_F = Celsius2Fahrenheit(max);
									// transferir índexos mínim i màxim
	mmres->id_min = idmin;
	mmres->id_max = idmax;

	return(avg);
}
