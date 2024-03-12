/*---------------------------------------------------------------------
|   Declaració de variables globals definides en "data.c", 
|	amb informació per al programa "geotemp.c" .
| ---------------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Març 2021, Març 2022, Març 2023, Març 2024)
| ---------------------------------------------------------------------*/

#ifndef DATAGEOTEMP_H
#define DATAGEOTEMP_H

#include "Q13.h"				// definició tipus Q13
#include "geotemp.h"			// definitició tipus t_cityinfo

		/* declaracions estructures de dades externes amb les dades */
#define NUMCITIESHNORD	18
#define NUMCITIESHSUD	19

extern Q13 tempHNord_2020[NUMCITIESHNORD][12];
extern Q13 tempHSud_2020[NUMCITIESHSUD][12];

extern t_cityinfo info_HNord[NUMCITIESHNORD];
extern t_cityinfo info_HSud[NUMCITIESHSUD];

#endif 	/* DATAGEOTEMP_H */
