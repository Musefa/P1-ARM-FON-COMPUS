@;----------------------------------------------------------------
@;	Q13.s: rutines aritm�tiques en format coma fixa 1:18:13.
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------
.include "Q13.i" 													@; M�scares Q13 en GAS.

@;----------------------------------------------------------------
@;	add_Q13(): calcula i retorna la suma de 2 operands codificats
@;			   en coma fixa 1:18:13, i indica si s'ha produ�t o no
@;			   overflow.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R3 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = suma dels dos nombres.
@;----------------------------------------------------------------
	.global add_Q13
add_Q13:
		push {r4, lr}
		mov r4, #0													@; unsigned char ov = 0, inicialment s'assumeix que no hi ha overflow.
		adds r0, r1													@; R0 += R1 --> suma = num1 + num2; S'actualitzen els flags per tal
																	@; de saber si s'ha produ�t overflow.
		movvs r4, #1												@; Si hi ha overflow (prediaci� vs, overflow set), es canvia l'estat de
																	@; de ov = 1;
		strb r4, [r3]												@; *overflow = ov;
		pop {r4, pc}
		
@;----------------------------------------------------------------
@;	sub_Q13(): calcula i retorna la suma de 2 operands codificats
@;			   en coma fixa 1:18:13, i indica si s'ha produ�t o no
@;			   overflow.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R3 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = resta dels dos nombres.
@;----------------------------------------------------------------	

	.global sub_Q13
sub_Q13:
		push {r4, lr}
		mov r4, #0													@; unsigned char ov = 0, inicialment s'assumeix que no hi ha overflow.
		adds r0, r1													@; R0 -= R1 --> resta = num1 - num2; S'actualitzen els flags per tal
																	@; de saber si s'ha produ�t overflow.
		movvs r4, #1												@; Si hi ha overflow (prediaci� vs, overflow set), es canvia l'estat de
																	@; de ov = 1;
		strb r4, [r3]												@; *overflow = ov;
		pop {r4, pc}
		
@;----------------------------------------------------------------
@;	mul_Q13: calcula i retorna la multiplicaci� de 2 operands
@;			   codificats en coma fixa 1:18:13, i indica si s'ha
@;			   produ�t o no overflow.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R3 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = multiplicaci� dels dos nombres.
@;----------------------------------------------------------------
	.global mul_Q13
mul_Q13:
		push {lr}
		smull r0, r4, r2, r0										@; prod64 = num1 * num2, on Rlo = R0 i Rhi = R4. Es fa aix� perqu� el 
																	@; retorn del resultat es fa directament a trav�s de R0 (nom�s es
																	@; retornen els 32 bits baixos del producte.
		@; ------------------------------------------------------------------------------------------------------------------------------------------------
		@; DESPLA�AMENT L�GIC A LA DRETA D'UN NOMBRE DE 64 BITS EMMAGATZEMAT EN 2 REGISTRES
		@; Un cop realitzada la multiplicaci�, en coma fixa cal realitzar un ajust del resultat dividint per 2^f (sent f el nombre de bits emprats per 
		@; representar la part decimal del nombre, en el cas d'aquesta pr�ctica f = 13). Aquesta divisi� en ensamblador es pot traduir en un despla�ament
		@; l�gic a la dreta (lsr), ja que s'est� operant amb un nombre expressable com a pot�ncia de la base bin�ria (el nombre s'expressa com 2^f, la base
		@; elevada a quelcom).
		@; En la documentaci� oficial de l'assignatura, s'explica com realitzar un despla�ament l�gic a la dreta d'un nombre de 64 bits emmagatzemat en 2 
		@; registres per tal de no perdre informaci� (bits) en aquesta operaci�, ja que si es fes el despla�ament a la lleugera, els bits que sortissin per 
		@; la dreta del RdHi es perdrien, i per l'esquerra del RdLo entrarien un conjunt de 0, modificant indegudament el resultat.
		@; Sent d = nombre de bits que es volen despla�ar, l'explicaci� es la seg�ent:
		@; 		rsb R32-d, Rd, #32 --> Es guarda en un registre el nombre de bits amb els quals caldr� fer ajustaments, que �s el resultat de 32 - d.
		@; 		mov Rout, Rlo, lsl R32-d  
		@; 		mov Rout, Rout, lsr R32-d --> Es guarden els bits que sortirien per la dreta del RdLo i es col�loquen en un registre addicional.
		@;									  Aquest pas �s addicional, ja que el que es guarda �s el residu de la divisi� i pot interessar o no.
		@; 		mov Rlo, Rlo, lsr Rd --> Es despla�a a la dreta la part baixa (els bits que surten, residu, s'han guardat o s'ignoren i es perden, depenent 
		@;								 del que es vulgui.
		@; 		orr Rlo, Rhi, lsl R32-d --> Quan Rhi rep el despla�ament de lsl R32-d, al registre Rhi queden els bits que sortirien per la dreta si es fes
		@;									un lsr a la lleugera, per� emmagatzemats en la part alta, ocupant d bits. Com a Rlo els primers d bits de m�s 
		@; 									pes s�n 0, es pot realitzar una orr per tal de filtrar el bits d que sortirien i guardar-los al registre Rlo, 
		@; 									simulant un lsr correcte sense p�rdues de bits. Com als 32 - d bits de menys pes restants de Rhi hi queden 0,
		@;									els 32 - d bits de menys pes del Rlo no patiran modificacions.
		@; 		mov Rhi, Rhi, lsr Rd --> Es desplacen els d bits a la dreta en el registre Rhi.
		@; Ara b�, en aquesta pr�ctica es fan �nicament les seg�ents dues operacions:
		
		mov r0, r0, lsr #13
		orr r0, r1, lsl #(32-19)
		
		
		pop {pc}
