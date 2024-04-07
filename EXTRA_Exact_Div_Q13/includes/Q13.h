/*-----------------------------------------------------------------
|   Declaració de tipus, màscares i macro del format Q13, és a dir, 
|	en format Coma Fixa 1:18:13.
|	També declaracions de les 4 operacions add/sub/mul/div_Q13.
| -----------------------------------------------------------------
|	pere.millan@urv.cat
|	santiago.romani@urv.cat
|	(Març 2021, Febrer 2022, Març 2023, Març 2024)
| ----------------------------------------------------------------*/

#ifndef Q13_H
#define Q13_H


/* Declaració de tipus Coma Fixa 1:18:13 
		 1 bit  de signe (bit 31), =0 -> positiu, =1 -> negatiu
		18 bits de part entera (bits 30..13), aprox. 5-6 dígits en base 10
		13 bits de part fraccionària (bits 12..0), aprox. 3-4 dígits en base 10
*/
typedef int Q13;


/* Macro per convertir valors reals en valors Coma Fixa 1:18:13
		Exemples:
		MAKE_Q13(3.1416) --> 0x00006488
		MAKE_Q13(-5.125) --> 0xFFFF5C00
*/
#define MAKE_Q13(real)	(int)((real)*(1<<13)+(real<0?-0.5:0.5)) 


/* MÀSCARES per als camps de bits de valors 1:18:13 */
#define MASK_SIGN	0x80000000	/* bit 31:		signe */
#define MASK_INT	0x7FFFE000	/* bits 30..13:	part entera */
#define MASK_FRAC	0x00001FFF	/* bits 12..0:	part fraccionària */



/* Operacions aritmètiques bàsiques en Coma Fixa 1:18:13 */

/* add_Q13():	calcula i retorna la suma dels 2 primers operands,
  (num1 + num2) codificats en coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
extern Q13 add_Q13(Q13 num1, Q13 num2, unsigned char * overflow);


/* sub_Q13():	calcula i retorna la diferència dels 2 primers operands,
  (num1 - num2) codificats en coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
extern Q13 sub_Q13(Q13 num1, Q13 num2, unsigned char * overflow);


/* mul_Q13():	calcula i retorna el producte dels 2 primers operands,
  (num1 * num2) codificats en Coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
extern Q13 mul_Q13(Q13 num1, Q13 num2, unsigned char * overflow);


/* div_Q13():	calcula i retorna la divisió dels 2 primers operands,
  (num1 / num2) codificats en Coma fixa 1:18:13.
				El 3r paràmetre (per referència) retorna l'overflow:
				0: no s'ha produït overflow, resultat correcte.
				1: hi ha overflow (resultat massa gran) i el que es
				   retorna són els bits baixos del resultat.
*/
extern Q13 div_Q13(Q13 num1, Q13 num2, unsigned char * overflow);


#endif /* Q13_H */
