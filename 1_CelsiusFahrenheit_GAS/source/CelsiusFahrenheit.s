@;----------------------------------------------------------------
@;  CelsiusFahrenheit.s: rutines de conversió de temperatura en 
@;						 format Q13 (Coma Fixa 1:18:13). 
@;----------------------------------------------------------------
@;	santiago.romani@urv.cat
@;	pere.millan@urv.cat
@;	(Març 2021, Març 2022, Març 2023, Febrer 2024)
@;----------------------------------------------------------------
@;	Programador/a 1: eric.garcia@estudiants.urv.cat
@;	Programador/a 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------*/

.include "Q13.i"


.text
		.align 2
		.arm
		
@; CONSTANTS (càlcul en documentació i vídeos de la pràctica).
Q13_9_5 = 0x0000399A
Q13_5_9 = 0x000011C7

@; Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
@;						temperatura equivalent en graus Fahrenheit, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input * 9/5) + 32.0;
	.global Celsius2Fahrenheit
Celsius2Fahrenheit:
		push {r1 - r3, lr}												@; Es fa un push dels registres que no han de retornar cap valor i dels quals no es
																		@; vol perdre informació. Com en r0 es retorna el resultat, no s'ha de fer push.
		ldr r3, =Q13_9_5												@; Es carrega el nombre 9/5 en codificació en coma fixa al registre r3. S'ha de fer
																		@; així ja que com la distància de separació del bit a 1 de major pes i el bit a 1
																		@; de menys pes és major a 8 bits no es pot emprar com a registre immediat.
																		@; D'aquesta manera, es fa que la constant sigui accessible ràpidament amb un únic
																		@; accés a memòria.
		smull r1, r2, r0, r3 											@; TempC * 9/5. r1 = RdLo, r2 = RdHi
		
		@; ------------------------------------------------------------------------------------------------------------------------------------------------
		@; DESPLAÇAMENT LÒGIC A LA DRETA D'UN NOMBRE DE 64 BITS EMMAGATZEMAT EN 2 REGISTRES----------------------------------------------------------------
		@; Un cop realitzada la multiplicació, en coma fixa cal realitzar un ajust del resultat dividint per 2^f (sent f el nombre de bits emprats per 
		@; representar la part decimal del nombre, en el cas d'aquesta pràctica f = 13). Aquesta divisió en ensamblador es pot traduir en un desplaçament
		@; lògic a la dreta (lsr), ja que s'està operant amb un nombre expressable com a potència de la base binària (el nombre s'expressa com 2^f, la base
		@; elevada a quelcom).
		@; En la documentació oficial de l'assignatura, s'explica com realitzar un desplaçament lògic a la dreta d'un nombre de 64 bits emmagatzemat en 2 
		@; registres per tal de no perdre informació (bits) en aquesta operació, ja que si es fes el desplaçament a la lleugera, els bits que sortissin per 
		@; la dreta del RdHi es perdrien, i per l'esquerra del RdLo entrarien un conjunt de 0, modificant indegudament el resultat.
		@; Sent d = nombre de bits que es volen desplaçar, l'explicació es la següent:
		@; 		rsb R32-d, Rd, #32 --> Es guarda en un registre el nombre de bits amb els quals caldrà fer ajustaments, que és el resultat de 32 - d.
		@; 		mov Rout, Rlo, lsl R32-d  
		@; 		mov Rout, Rout, lsr R32-d --> Es guarden els bits que sortirien per la dreta del RdLo i es col·loquen en un registre addicional.
		@;									  Aquest pas és addicional, ja que el que es guarda és el residu de la divisió i pot interessar o no.
		@; 		mov Rlo, Rlo, lsr Rd --> Es desplaça a la dreta la part baixa (els bits que surten, residu, s'han guardat o s'ignoren i es perden, depenent 
		@;								 del que es vulgui.
		@; 		orr Rlo, Rhi, lsl R32-d --> Quan Rhi rep el desplaçament de lsl R32-d, al registre Rhi queden els bits que sortirien per la dreta si es fes
		@;									un lsr a la lleugera, però emmagatzemats en la part alta, ocupant d bits. Com a Rlo els primers d bits de més 
		@; 									pes són 0, es pot realitzar una orr per tal de filtrar el bits d que sortirien i guardar-los al registre Rlo, 
		@; 									simulant un lsr correcte sense pèrdues de bits. Com als 32 - d bits de menys pes restants de Rhi hi queden 0,
		@;									els 32 - d bits de menys pes del Rlo no patiran modificacions.
		@; 		mov Rhi, Rhi, lsr Rd --> Es desplacen els d bits a la dreta en el registre Rhi.
		@; Ara bé, en aquesta pràctica es fan únicament les següents dues operacions:
	
		mov r1, r1, lsr #13												
		orr r0, r1, r2, lsl #(32-13)

		@; Això es deu a que no s'empra un registre addicional per guardar el 32 - d bits (s'empren valors immediats i s'escriu com una resta, en el procés
		@; d'ensamblatge ja queda reflectit el nombre 19 final resultat de 32 - 13), no es guarden els bits que sortirien per la dreta del Rlo (el residu, 
		@; que no interessa en el context de la pràctica) i no es fa el desplaçament a la dreta de la part alta, ja que com al final s'acaba guardant el
		@; resultat del Rlo únicament, no cal arreglar/ajustar Rhi, perdent temps inútilment.
		@; Addicionalment, el resultat de l'orr es guarda a r0 en comptes de al Rlo (r1), per facilitar després el retorn sense necessitat de relitzar un
		@; mov addicional.
		@; ------------------------------------------------------------------------------------------------------------------------------------------------
																		
		add r0, #0x00040000 											@; Es suma el desplaçament en l'escala Fahrenheit. No cal sumar res al Rhi (r2) 
																		@; perquèes perd aquesta informació, per tant tampoc cal actualitzar els flags.
		pop {r1 - r3, pc}												@; Es fa un pop als registres emprats en la funció amb els valors previs a 
																		@; l'execució d'aquesta i al pc per fer efectiu el retorn de la funció al main.


@; Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
@;						temperatura equivalent en graus Celsius, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input - 32.0) * 5/9;
	.global Fahrenheit2Celsius
Fahrenheit2Celsius:
		push {r1 - r3, lr}
		sub r0, #0x00040000												@; Es resta el desplaçament en l'escala Fahrenheit.
		ldr r3, =Q13_5_9												@; Es carrega el nombre 5/9 en codificació en coma fixa al registre r3. S'ha de fer
																		@; així ja que com la distància de separació del bit a 1 de major pes i el bit a 1
																		@; de menys pes és major a 8 bits no es pot emprar com a registre immediat.
		smull r1, r2, r0, r3 											@; (TempF - 32) * 5/9. r1 = RdLo, r2 = RdHi
		
		@; Es realitza la correcció del resultat amb un desplaçament lògic a la dreta (lsr) sobre un nombre de 64 bits. La justificació del procediment i 
		@; del perquè de la reducció d'operacions queda explicada en els comentaris de la funció superior.									
		mov r1, r1, lsr #13																										
		orr r0, r1, r2, lsl #(32-13)																								
		pop {r1 - r3, pc}												@; Es fa un pop als registres emprats en la funció amb els valors previs a 
																		@; l'execució d'aquesta i al pc per fer efectiu el retorn de la funció al main.

.end
