@;----------------------------------------------------------------
@;	CelsiusFahrenheit_lib.s: adaptació de les rutines de conversió
@;							 de temperatura en Q13 de la fase 1 
@;							 amb les rutines de libQ13.a
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------

@; CONSTANTS (càlcul en documentació i vídeos de la pràctica).
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
	.global Celsius2Fahrenheit									@; Es podria canviar el nom de la rutina per tal de diferenciar.la
																@; de la de la fase 1, però com aquests arxius es cridaran per 
																@; l'assemblador juntament amb els de test, no cal fer la 
																@; diferenciació. A més, caldria modificar tots els noms de les 
																@; funcions en aquests arxius de test.
Celsius2Fahrenheit:
		push {r1, r2, lr}
		ldr r1, =Q13_9_5										@; Es carrega el nombre 9/5 en codificació en coma fixa al registre r3. S'ha de fer
																@; així ja que com la distància de separació del bit a 1 de major pes i el bit a 1
																@; de menys pes és major a 8 bits no es pot emprar com a registre immediat.
																@; D'aquesta manera, es fa que la constant sigui accessible ràpidament amb un únic
																@; accés a memòria.
		sub sp, #4												@; Espai en pila per la dir mem de l'overflow.
		mov r2, sp
		bl mul_Q13												@; 1a part càlcul: resultat = (input * 9/5).
		mov r1, #Q13_32											@; Es mou la constant Q13_32 com a valor immediat a r1 per la crida de la funció.
																@; Cal adonar-se que en la fase 1 aquest moviment era innecessari, ja que es podia
																@; incrementar directament el valor de r0, on hi havia el resultat.
		bl add_Q13												@; 2a part càlcul: resultat = (input * 9/5) + 32.0. El resultat queda en r0, llest 
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
	.global Fahrenheit2Celsius									@; Es podria canviar el nom de la rutina per tal de diferenciar.la
																@; de la de la fase 1, però com aquests arxius es cridaran per 
																@; l'assemblador juntament amb els de test, no cal fer la 
																@; diferenciació. A més, caldria modificar tots els noms de les 
																@; funcions en aquests arxius de test.
Fahrenheit2Celsius:
		push {r1, r2, lr}
		ldr r1, =Q13_32											@; Es mou la constant Q13_32 com a valor immediat a r1 per la crida de la funció.
																@; Cal adonar-se que en la fase 1 aquest moviment era innecessari, ja que es podia
																@; incrementar directament el valor de r0, on hi havia el resultat.
		sub sp, #4												@; Espai en pila per la dir mem de l'overflow.
		mov r2, sp
		bl sub_Q13												@; 1a part càlcul: resultat = (input - 32.0)
		ldr r1, =Q13_5_9										@; Es carrega el nombre 5/9 en codificació en coma fixa al registre r3. S'ha de fer
																@; així ja que com la distància de separació del bit a 1 de major pes i el bit a 1
																@; de menys pes és major a 8 bits no es pot emprar com a registre immediat.
																@; D'aquesta manera, es fa que la constant sigui accessible ràpidament amb un únic
																@; accés a memòria.
		bl mul_Q13												@; 2a part càlcul: resultat = (input - 32.0) * 5/9. El resultat queda en r0, llest
																@; pel retorn de la rutina.
		add sp, #4												@; Es recupera l'espai emprat a la pila.
		pop {r1, r2, pc}
.end
