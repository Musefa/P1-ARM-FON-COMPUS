/*----------------------------------------------------------------
|   CelsiusFahrenheit.c: rutines de conversió de temperatura en 
|						 format Q13 (Coma Fixa 1:18:13). 
|		Implementació cridant rutines aritmètiques libQ13.
| ----------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Març 2021, Febrer 2022, Març 2023, Febrer 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"	/* Q13: tipus Coma Fixa 1:18:13
					   MAKE_Q13(real): codifica un valor real en format Q13
					   MASK_SIGN: màscara per obtenir el bit de signe
					   add/sub/mul_Q13: rutines llibreria Q13
					*/


/* Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
						temperatura equivalent en graus Fahrenheit, utilitzant
						valors codificats en Coma Fixa 1:18:13.
	resultat = (input * 9/5) + 32.0;
*/
Q13 Celsius2Fahrenheit(Q13 input)
{
	Q13 resultat;
	unsigned char overflow;

		// 1a part càlcul: resultat = (input * 9/5)
	resultat = mul_Q13(input, MAKE_Q13(9.0/5.0), &overflow);
	
		// 2a part càlcul: resultat = (input * 9/5) + 32.0
	resultat = add_Q13(resultat, MAKE_Q13(32.0), &overflow);

	return(resultat);
}


/* Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
						temperatura equivalent en graus Celsius, utilitzant
						valors codificats en Coma Fixa 1:18:13.
	resultat = (input - 32.0) * 5/9;
*/
Q13 Fahrenheit2Celsius(Q13 input)
{
	Q13 resultat;
	unsigned char overflow;

		// 1a part càlcul: resultat = (input - 32.0)
	resultat = sub_Q13(input, MAKE_Q13(32.0), &overflow);

		// 2a part càlcul: resultat = (input - 32.0) * 5/9
	resultat = mul_Q13(resultat, MAKE_Q13(5.0/9.0), &overflow);

	return(resultat);
}

