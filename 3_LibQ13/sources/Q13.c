/*----------------------------------------------------------------
|   Q13.c: rutines aritmètiques en format Coma Fixa 1:18:13. 
| ----------------------------------------------------------------
|	pere.millan@urv.cat
|	santiago.romani@urv.cat
|	(Abril 2021, Març 2022, Març 2023, Març 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"	/* Q13: tipus Coma Fixa 1:18:13
					   MAKE_Q13(real): codifica un valor real en format Q13
					   MASK_SIGN: màscara per obtenir el bit de signe
					*/
#include "divmod.h"		/* rutina div_mod() de divisió entera */

	/* MÀSCARA per als 33 bits alts d'una multiplicació llarga */
#define MASK_SIGN_64	0xFFFFFFFF80000000	/* bits 63..31 */


/* Operacions aritmètiques bàsiques en Coma Fixa 1:18:13 */

/* add_Q13():	calcula i retorna la suma dels 2 primers operands,
  (num1 + num2)	codificats en Coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
Q13 add_Q13(Q13 num1, Q13 num2, unsigned char * overflow)
{
	Q13 suma;
	unsigned char ov = 0;	// inicialment assumeix que no hi ha overflow
	
	suma = num1 + num2;
	
		// Detecció overflow
	if (((MASK_SIGN & num1) == (MASK_SIGN & num2)) 
			&& ((MASK_SIGN & num1) != (MASK_SIGN & suma)))
		ov = 1;
	
	*overflow = ov;
	return(suma);
}


/* sub_Q13():	calcula i retorna la resta dels 2 primers operands,
  (num1 - num2) codificats en Coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
Q13 sub_Q13(Q13 num1, Q13 num2, unsigned char * overflow)
{
	Q13 resta;
	unsigned char ov = 0;	// inicialment assumeix que no hi ha overflow
	
	resta = num1 - num2;
	
		// Detecció overflow
	if (((MASK_SIGN & num1) != (MASK_SIGN & num2)) 
			&& ((MASK_SIGN & num1) != (MASK_SIGN & resta)))
		ov = 1;
	
	*overflow = ov;
	return(resta);
}


/* mul_Q13():	calcula i retorna el producte dels 2 primers operands,
  (num1 * num2)	codificats en Coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
Q13 mul_Q13(Q13 num1, Q13 num2, unsigned char * overflow)
{
	Q13 producte;
	unsigned char ov = 0;	// inicialment assumeix que no hi ha overflow

	long long prod64;		// Resultat de la multiplicació (64 bits)

		// Calcular resultat (64 bits), ajustant bits fracció
	prod64 = (((long long) num1) * num2) >> 13;

		// Detecció overflow
	if (prod64 < 0)
	{		// Si resultat negatiu, els bits 63..31 haurien de ser tots 1
		if ((prod64 & MASK_SIGN_64) != MASK_SIGN_64)
			ov = 1;
	}
	else
	{		// Si resultat positiu, els bits 63..31 haurien de ser tots 0
		if ((prod64 & MASK_SIGN_64) != 0)
			ov = 1;
	}

	producte = (Q13) prod64;		// Retornar només els 32 bits baixos

	*overflow = ov;
	return(producte);
}


/* div_Q13():	calcula i retorna la divisió dels 2 primers operands,
  (num1 / num2) codificats en Coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
Q13 div_Q13(Q13 num1, Q13 num2, unsigned char * overflow)
{
	Q13 divisio;
	unsigned char ov = 0;	// inicialment assumeix que no hi ha overflow
	unsigned int quo, res;	// Quocient i residu de div_mod()
	unsigned char op2neg;	// El segon operand és negatiu?
	unsigned int abs2;		// Valor absolut del segon operand

		// En cas de divisió entre 0, resultat 0 i Overflow
	if (num2 == 0)
	{
		divisio = 0;
		ov = 1;
	}
	else
	{	// Calcular divisió amb valor invers: a/b = a * (1/b)
			
			// Calcular valor absolut del segon operand
		op2neg = (num2 < 0);
		abs2 = (op2neg ? -num2 : num2);
			
			// Calcular valor invers Q13: quo = 1.0/den (ajustant bits numerador)
		div_mod( MAKE_Q13(1.0) << 13, abs2, &quo, &res);
			
			// Calcular resultat num1 * 1.0/num2, fixant overflow
		divisio = mul_Q13(num1, quo, &ov);
			
			// Canviar signe del resultat
		if (op2neg)
			divisio = -divisio;
	}

	*overflow = ov;
	return(divisio);
}

