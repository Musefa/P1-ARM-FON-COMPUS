@;----------------------------------------------------------------
@;	CelsiusFahrenheit_exact_lib.s: adaptaci� de les rutines de 
@;  							   conversi� de temperatura en Q13  
@;							       de la fase 1 amb les rutines de 
@;								   xlibQ13.a
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------

.include "Q13.i"

@; CONSTANTS (c�lcul en documentaci� i v�deos de la pr�ctica).
Q13_9_5 = 0x0000399A
Q13_5_9 = 0x000011C7
Q13_32 = 0x00040000

.text
		.align 2
		.arm
@;----------------------------------------------------------------------------
@; Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
@;						temperatura equivalent en graus Fahrenheit, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input * 9/5) + 32.0;
@;----------------------------------------------------------------------------
	.global Celsius2Fahrenheit									@; Es podria canviar el nom de la rutina per tal de diferenciar-la
																@; de la de la fase 1, per� com aquests arxius es cridaran per 
																@; l'assemblador juntament amb els de test, no cal fer la 
																@; diferenciaci�. A m�s, caldria modificar tots els noms de les 
																@; funcions en aquests arxius de test.
Celsius2Fahrenheit:
		push {r1, r2, lr}
		ldr r1, =Q13_9_5										@; Es carrega el nombre 9/5 en codificaci� en coma fixa al registre r3. S'ha de fer
																@; aix� ja que com la dist�ncia de separaci� del bit a 1 de major pes i el bit a 1
																@; de menys pes �s major a 8 bits no es pot emprar com a registre immediat.
																@; D'aquesta manera, es fa que la constant sigui accessible r�pidament amb un �nic
																@; acc�s a mem�ria.
		sub sp, #4												@; Espai en pila per la dir mem de l'overflow.
		mov r2, sp
		bl mul_Q13												@; 1a part c�lcul: resultat = (input * 9/5).
		mov r1, #Q13_32											@; Es mou la constant Q13_32 com a valor immediat a r1 per la crida de la funci�.
																@; Cal adonar-se que en la fase 1 aquest moviment era innecessari, ja que es podia
																@; incrementar directament el valor de r0, on hi havia el resultat.
		bl add_Q13												@; 2a part c�lcul: resultat = (input * 9/5) + 32.0. El resultat queda en r0, llest 
																@; pel retorn de la rutina.	
		add sp, #4												@; Es recupera l'espai emprat a la pila.
		pop {r1, r2, pc}

@;----------------------------------------------------------------------------
@; Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
@;						temperatura equivalent en graus Celsius, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input - 32.0) * 5/9;
@;----------------------------------------------------------------------------
	.global Fahrenheit2Celsius									@; Es podria canviar el nom de la rutina per tal de diferenciar-la
																@; de la de la fase 1, per� com aquests arxius es cridaran per 
																@; l'assemblador juntament amb els de test, no cal fer la 
																@; diferenciaci�. A m�s, caldria modificar tots els noms de les 
																@; funcions en aquests arxius de test.
Fahrenheit2Celsius:
		push {r1, r2, lr}
		ldr r1, =Q13_32											@; Es mou la constant Q13_32 com a valor immediat a r1 per la crida de la funci�.
																@; Cal adonar-se que en la fase 1 aquest moviment era innecessari, ja que es podia
																@; incrementar directament el valor de r0, on hi havia el resultat.
		sub sp, #4												@; Espai en pila per la dir mem de l'overflow.
		mov r2, sp
		bl sub_Q13												@; 1a part c�lcul: resultat = (input - 32.0)
		ldr r1, =Q13_5_9										@; Es carrega el nombre 5/9 en codificaci� en coma fixa al registre r3. S'ha de fer
																@; aix� ja que com la dist�ncia de separaci� del bit a 1 de major pes i el bit a 1
																@; de menys pes �s major a 8 bits no es pot emprar com a registre immediat.
																@; D'aquesta manera, es fa que la constant sigui accessible r�pidament amb un �nic
																@; acc�s a mem�ria.
		bl mul_Q13												@; 2a part c�lcul: resultat = (input - 32.0) * 5/9. El resultat queda en r0, llest
																@; pel retorn de la rutina.
		add sp, #4												@; Es recupera l'espai emprat a la pila.
		pop {r1, r2, pc}
.end
