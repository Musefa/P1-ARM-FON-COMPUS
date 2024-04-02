@;----------------------------------------------------------------
@;	Q13.s: rutines aritmètiques en format coma fixa 1:18:13.
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------
.include "Q13.i" 													@; Màscares Q13 en GAS.

@;----------------------------------------------------------------
@;	add_Q13(): calcula i retorna la suma de 2 operands codificats
@;			   en coma fixa 1:18:13, i indica si s'ha produït o no
@;			   overflow.
@;		PARÀMETRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produït overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna són els bits baixos del resultat.
@;		RESULTAT -> R0 = suma dels dos nombres.
@;----------------------------------------------------------------
	.global add_Q13
add_Q13:
		push {r3, lr}
		mov r3, #0													@; unsigned char ov = 0, inicialment s'assumeix que no hi ha overflow.
		adds r0, r1													@; R0 += R1 --> suma = num1 + num2; S'actualitzen els flags per tal
																	@; de saber si s'ha produït overflow.
		movvs r3, #1												@; Si hi ha overflow (prediació vs, overflow set), es canvia l'estat de
																	@; de ov = 1;
		strb r3, [r2]												@; *overflow = ov;
		pop {r3, pc}
		
@;----------------------------------------------------------------
@;	sub_Q13(): calcula i retorna la suma de 2 operands codificats
@;			   en coma fixa 1:18:13, i indica si s'ha produït o no
@;			   overflow.
@;		PARÀMETRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produït overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna són els bits baixos del resultat.
@;		RESULTAT -> R0 = resta dels dos nombres.
@;----------------------------------------------------------------	

	.global sub_Q13
sub_Q13:
		push {r3, lr}
		mov r3, #0													@; unsigned char ov = 0, inicialment s'assumeix que no hi ha overflow.
		subs r0, r1													@; R0 -= R1 --> resta = num1 - num2; S'actualitzen els flags per tal
																	@; de saber si s'ha produït overflow.
		movvs r3, #1												@; Si hi ha overflow (prediació vs, overflow set), es canvia l'estat de
																	@; de ov = 1;
		strb r3, [r2]												@; *overflow = ov;
		pop {r3, pc}
		
@;----------------------------------------------------------------
@;	mul_Q13: calcula i retorna la multiplicació de 2 operands
@;			   codificats en coma fixa 1:18:13, i indica si s'ha
@;			   produït o no overflow.
@;		PARÀMETRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@; 			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produït overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna són els bits baixos del resultat.
@;		RESULTAT -> R0 = multiplicació dels dos nombres.
@;----------------------------------------------------------------
	.global mul_Q13
mul_Q13:
		push {r2, r3, lr}											@; Es fa push de r2 per poder operar amb aquest, i després fer pop per
																	@; accedir a memòria.
		smull r0, r3, r1, r0										@; prod64 = num1 * num2, on Rlo = R0 i Rhi = R4. Es fa així perquè el 
																	@; retorn del resultat es fa directament a través de R0 (només es
																	@; retornen els 32 bits baixos del producte.
		@; ------------------------------------------------------------------------------------------------------------------------------------------------
		@; DESPLAÇAMENT LÒGIC A LA DRETA D'UN NOMBRE DE 64 BITS EMMAGATZEMAT EN 2 REGISTRES
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
		@; Ara bé, en aquesta pràctica es fan únicament les següents tres operacions:
		
		mov r0, r0, lsr #13
		orr r0, r3, lsl #(32-19)									@; En r0 ja queda el resultat final.
		mov r3, r3, asr #13											@; Cal fer el desplaçament per controlar l'overflow.
		
		@; ACABAR DE REVISAR COMENTARIS MULTIPLICACIÓ.
		
		
		and r3, #MASK_NUM											@; S'analitza el signe del nombre resultat.
		cmp r3, #0													@; Tots els bits a 0 - és positiu.
		beq .LnoOverflow
		cmp r3, #MASK_NUM											@; Tots els bits a 1 - és negatiu
		beq .LnoOverflow
		@; Si s'arriba aquí, ni tots els bits estan a 1 ni tots els bits estan a 0 - OVERFLOW!!!.
		mov r3, #1													@; Com només es retornen els 32 bits baixos, s'empra r4 per char 
		b .Lcont
.LnoOverflow:
		mov r3, #0													@; No s'ha produït overflow.
.Lcont:
		pop {r2}													@; Es carrega la direcció de memòria de *overflow.
		strb r3, [r2]
		
		pop {r4, pc}

@;----------------------------------------------------------------		
@;	div_Q13: calcula i retorna la divisió dels 2 primers operands
@;           codificats en coma fixa 1:18:13, i indica si s'ha
@;			 produït overflow o no
@;		PARÀMETRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@;			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produït overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna són els bits baixos del resultat.
@;----------------------------------------------------------------
	.global div_Q13
div_Q13:
		push {r1, r2, r3, r10, lr}									 
		cmp r1, #0														
		moveq r9, #1												@; divisor == 0 -> no divisible, infinito, ov = 1; S'empra r9 per
																	@; reaprofitar millor després r3 (per la funció div_mod).
		moveq r0, #0												@; Cocient igual a 0.
		b .LendDiv
		@; Inversió de num2.
		sub sp, #8													@; Es reserva espai a la pila per dos variables locals, pel quo i mod de la subrutina div_mod.
		mov r10, r2													@; Es salva el contingut de r2 a r10 (dir mem overflow).
		mov r11, r3													@; Es salva el contingut de r3 a r11 (.
		mov r2, sp													@; R2 = dir mem cociente. Per push anterior es pot fer aquesta operació. Es perd l'índex de posició, però
																	@; com no s'empra més no passa res.
		add r3, sp, #4												@; R3 = dir mem residuo. No s'empra després, però cal indicar-ho per la subrutina div_mod.
		mov r8, r0													@; Es salva el contingut de r0 (num1).
		mov r0, #0x08													@; r0 = MAKE_Q13(1) << 13 per la crida de div mod.
		
		and r12, r1, #MASK_SIGN										@; R12 = SIGNE DE R1, num2.
		cmp r12, #0													@; Si R12 = 0, R0 > 0, si no, no.
		beq .Lnotminus												@; num2 és positiu o negatiu ???
		rsb r1, #1													@; num2 = - num2 en Ca2 (Q13)
		bl div_mod													@; Llamada a rutina div_mod().
		ldr r1, [r2]												@; Es carrega de R2 1/num2.
		rsb r1, #1													@; num2 = - num2 en Ca2 (Q13)
		b .Lyetdivided												@; Es salta a l'etiqueta de divisió completada.
.Lnotminus:
		bl div_mod
		ldr r1, [r2]
.Lyetdivided:
		@;Multiplicació de num1*(1/num2).
		mov r0, r8													@; Es recupera num1 a r0.
		bl mul_Q13
		ldrb r9, [r2]												@; Es carrega a r9 l'estat de l'overflow. 

.LendDiv:
		pop {r1, r2}												@; Es recupera l'adreça de *overflow (i num2 original per tal de recuperar
																	@; correctament els valors de la pila).
		strb r3, [r2]												@; *overflow = ov;
		pop {r3, r10, pc}