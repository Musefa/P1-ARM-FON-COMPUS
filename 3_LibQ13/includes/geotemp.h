/*---------------------------------------------------------------------
|   Declaració de tipus per a informació del programa "geotemp.c".
| ---------------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Març 2021)
| ---------------------------------------------------------------------*/

#ifndef GEOTEMP_H
#define GEOTEMP_H

  	/* declaració del tipus t_cityinfo */
typedef struct
{	
	char *name;			// nom de la ciutat
	char scale;			// escala utilitzada ('C': Celsius, 'F': Fahrenheit)
} t_cityinfo;


#endif 	/* GEOTEMP_H */
