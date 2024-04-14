@;----------------------------------------------------------------
@;	Q13.s: rutines aritm�tiques en format coma fixa 1:18:13.
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------

.include "Q13.i" 													@; M�scares Q13 en GAS.
Q13_1_LSL_13 = 0x04000000											@; Constant de MAKE_Q13(1) << 13

@;----------------------------------------------------------------
@;	add_Q13(): calcula i retorna la suma de 2 operands codificats
@;			   en coma fixa 1:18:13, i indica si s'ha produ�t o no
@;			   overflow.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = suma dels dos nombres.
@;----------------------------------------------------------------
	.global add_Q13
add_Q13:
		push {r3, lr}
		mov r3, #0													@; unsigned char ov = 0, inicialment s'assumeix que no hi ha overflow.
		adds r0, r1													@; R0 += R1 --> suma = num1 + num2; S'actualitzen els flags per tal
																	@; de saber si s'ha produ�t overflow.
		movvs r3, #1												@; Si hi ha overflow (predicaci� vs, overflow set), es canvia l'estat de
																	@; de ov = 1;
		strb r3, [r2]												@; *overflow = ov;
		pop {r3, pc}
		
@;----------------------------------------------------------------
@;	sub_Q13(): calcula i retorna la suma de 2 operands codificats
@;			   en coma fixa 1:18:13, i indica si s'ha produ�t o no
@;			   overflow.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = resta dels dos nombres.
@;----------------------------------------------------------------	

	.global sub_Q13
sub_Q13:
		push {r3, lr}
		mov r3, #0													@; unsigned char ov = 0, inicialment s'assumeix que no hi ha overflow.
		subs r0, r1													@; R0 -= R1 --> resta = num1 - num2; S'actualitzen els flags per tal
																	@; de saber si s'ha produ�t overflow.
		movvs r3, #1												@; Si hi ha overflow (predicaci� vs, overflow set), es canvia l'estat de
																	@; de ov = 1;
		strb r3, [r2]												@; *overflow = ov;
		pop {r3, pc}
		
@;----------------------------------------------------------------
@;	mul_Q13: calcula i retorna la multiplicaci� de 2 operands
@;			   codificats en coma fixa 1:18:13, i indica si s'ha
@;			   produ�t o no overflow.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = multiplicaci� dels dos nombres.
@;----------------------------------------------------------------
	.global mul_Q13
mul_Q13:
		push {r3, lr}												@; Es fa push de r2 per poder operar amb aquest, i despr�s fer pop per
																	@; accedir a mem�ria, ja que no cal accedir a aquesta variable fins al
																	@; final de la rutina i �s un registre emprable.
		smull r0, r3, r1, r0										@; prod64 = num1 * num2, on Rlo = R0 i Rhi = R4. Es fa aix� perqu� el 
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
		@; Ara b�, en aquesta part de la pr�ctica es fan �nicament les seg�ents tres operacions:
		
		mov r0, r0, lsr #13
		orr r0, r3, lsl #(32-13)									@; En r0 ja queda el resultat final.
		mov r3, r3, asr #13											@; Cal fer el despla�ament per controlar l'overflow.
		
		@; A difer�ncia de la primera part de la pr�ctica, aqu� cal fer un asr #13 per tal d'analitzar els bits alts de la multiplicaci� i comprovar si
		@; s'ha produ�t (o no) overflow.
		
		
		tst r0, #MASK_SIGN											@; S'analitza el signe del nombre resultat (primer signe del registre amb
																	@; els 32 bits baixos.
		mvnne r3, r3												@; S'inverteix r3 en cas que el nombre sigui negatiu. Si fos negatiu, tots
																	@; els bits en r3 haurien d'estar a 1 (si no s'ha produ�t overflow), per tant 
																	@; amb aquesta instrucci� passaran a estar a 0.
		cmp r3, #0
		movne r3, #1
		moveq r3, #0												@; Si r3 == 0, independentment del signe (ja que s'ha realitzat un mvn 
																	@; previ) no s'ha produ�t overflow (r3 = ov = 0). En cas que no sigui
																	@; aix�, hi ha overflow (r3 = ov = 1). S'empra r3 perqu� no es retorna
																	@; la part alta, i ens queda informaci� inservible per la resta de la
																	@; subrutina.
		strb r3, [r2]												@; *overflow = ov;
		
		pop {r3, pc}

@;----------------------------------------------------------------		
@;	div_Q13: calcula i retorna la divisi� dels 2 primers operands
@;           codificats en coma fixa 1:18:13, i indica si s'ha
@;			 produ�t overflow o no
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@;			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = divisi� dels dos nombres.
@;----------------------------------------------------------------
	.global div_Q13
div_Q13:
		push {r1 - r6, lr}											@; Es fa push de r1 perqu� pot patir modificacions (canvi de signe), i de r2 per 
																	@; fer un pop final i recuperar l'adre�aabans de la c�rrega a mem�ria.
		cmp r1, #0														
		moveq r4, #1												@; divisor == 0 -> no divisible, infinit, ov = 1; S'empra r4 per
																	@; reaprofitar millor despr�s r3 (per la funci� div_mod).
		moveq r0, #0												@; Quocient igual a 0.
		beq .LendDiv
		@; Inversi� de num2.
		@; No s'inicialitza ov perqu� quedar� ja inicialitzat a posteriori, amb el resultat de mul_Q13.
		sub sp, #8													@; Es reserva espai a la pila per dos variables locals, pel quo i mod de la subrutina div_mod.
		mov r2, sp													@; R2 = dir mem quocient. Per push anterior es pot fer aquesta operaci�.
		add r3, sp, #4												@; R3 = dir mem residu. No s'empra despr�s, per� cal indicar-ho per la subrutina div_mod.
		mov r5, r0													@; Es salva el contingut de r0 (num1).
		mov r0, #Q13_1_LSL_13										@; r0 = MAKE_Q13(1) << 13 per la crida de div mod.
		
		and r6, r1, #MASK_SIGN										@; R6 = SIGNE DE R1, num2.
		cmp r6, #0													@; Si R6 = 0, R1 > 0, si no, no.
		rsbne r1, #0												@; num2 = - num2 en Ca2 (Q13). Si no es negatiu, no cal fer-ho (predicaci� ne).
		bl div_mod													@; Llamada a rutina div_mod().
		ldr r1, [r2]												@; Es carrega de R2 a R1 1/num2 (quocient divisi� feta).
		mov r0, r5													@; Es recupera num1 a r0. r1 ja t� carregat 1/num2, i r2 t� ja carregat
																	@; una adre�a de mem�ria (la del quocient). Com no es tornar� a consultar
																	@; el cocient, es pot emprar aquesta mateixa direcci� i sobreescriure-hi
																	@; informaci�.
		bl mul_Q13
		cmp r6, #0													@; Es torna a comprovar si el signe original de num2 era negatiu
		rsbne r0, #0												@; i en cas que ho fos, es canvia de signe el resultat final.
		ldrb r4, [r2]												@; Es carrega a r4 l'estat de l'overflow retornat de mul_Q13 
		add sp, #8													@; Es restaura l'estat de l'stack pointer (sp). Variables de la pila ja
																	@; emprades.

.LendDiv:
		pop {r1, r2}												@; Es recupera l'adre�a de *overflow (i num2 original per tal de recuperar
																	@; correctament els valors de la pila).
		strb r4, [r2]												@; *overflow = ov;
		pop {r3 - r6, pc}											@; Es fa el pop de la resta de valors de la pila i es retorna la funci�.
.end
