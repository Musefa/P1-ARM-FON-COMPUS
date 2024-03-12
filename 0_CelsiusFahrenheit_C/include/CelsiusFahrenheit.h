/*---------------------------------------------------------------------
|   Declaració de prototipus de funcions de conversió de temperatures,
|	en format Coma Fixa 1:18:13.
| ---------------------------------------------------------------------
|	pere.millan@urv.cat
|	santiago.romani@urv.cat
|	(Març 2021, Febrer 2022, Març 2023, Febrer 2024)
| ---------------------------------------------------------------------*/

#ifndef CELSIUSFAHRENHEIT_H
#define CELSIUSFAHRENHEIT_H

#include "Q13.h"

/* Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
						temperatura equivalent en graus Fahrenheit, utilitzant
						valors codificats en Coma Fixa 1:18:13.
	output = (input * 9/5) + 32.0;
*/
extern Q13 Celsius2Fahrenheit(Q13 input);

/* Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
						temperatura equivalent en graus Celsius, utilitzant
						valors codificats en Coma Fixa 1:18:13.
	output = (input - 32.0) * 5/9;
*/
extern Q13 Fahrenheit2Celsius(Q13 input);


#endif /* CELSIUSFAHRENHEIT_H */
