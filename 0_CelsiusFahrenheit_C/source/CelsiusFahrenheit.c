/*----------------------------------------------------------------
|   CelsiusFahrenheit.c: rutines de conversió de temperatura en 
|						 format Q13 (Coma Fixa 1:18:13). 
| ----------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Març 2021, Febrer 2022, Març 2023, Febrer 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"	/* Q13: tipus Coma Fixa 1:18:13
					   MAKE_Q13(real): codifica un valor real en format Q13
					   MASK_SIGN: màscara per obtenir el bit de signe
					*/


/* Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
						temperatura equivalent en graus Fahrenheit, utilitzant
						valors codificats en Coma Fixa 1:18:13.
	output = (input * 9/5) + 32.0;
*/
Q13 Celsius2Fahrenheit(Q13 input)
{
	Q13 output;
	long long prod64;		// resultat de la multiplicació (64 bits)

		// ajust d'escala (input * 9/5), amb multiplicació de 64 bits
	prod64 = (((long long) input) * MAKE_Q13(9.0/5.0));
	
		// ajustar bits fraccionaris:
		//	prod64 = real(input) * 2^13 * real(9/5) * 2^13
		//	output = prod64 / 2^13 = real(input * 9/5) * 2^13
	output = (Q13) (prod64 >> 13);
	
	output += MAKE_Q13(32.0);		// afegir desplaçament d'escala Fahrenheit

	return(output);
}


/* Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
						temperatura equivalent en graus Celsius, utilitzant
						valors codificats en Coma Fixa 1:18:13.
	output = (input - 32.0) * 5/9;
*/
Q13 Fahrenheit2Celsius(Q13 input)
{
	Q13 output;
	long long prod64;		// resultat de la multiplicació (64 bits)

	input -= MAKE_Q13(32.0);		// treure desplaçament d'escala Fahrenheit
		
		// ajust d'escala ((input - 32.0) * 5/9), amb multiplicació de 64 bits
	prod64 = (((long long) input) * MAKE_Q13(5.0/9.0));
	
		// ajustar bits fraccionaris:
		//	prod64 = real(input - 32.0) * 2^13 * real(5/9) * 2^13
		//	output = prod64 / 2^13 = real(input - 32.0) * real(5/9) * 2^13
	output = (Q13) (prod64 >> 13);

	return(output);
}

