@;----------------------------------------------------------------
@;	exactQ13.s: rutines aritm�tiques en format coma fixa 1:18:13 i 
@;	amb la rutina de divisi� implementada de manera m�s exacta.
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
@;	exact_div_Q13: calcula i retorna la divisi� dels 2 primers 
@;           operands codificats en coma fixa 1:18:13, emprant una
@;			 metodologia de c�lcul m�s exacta.
@;		PAR�METRES:
@;			R0 -> num1, codificat en coma fixa 1:18:13
@;			R1 -> num2, codificat en coma fixa 1:18:13
@;			R2 -> estat de l'overflow (dir mem):
@;				0: no s'ha produ�t overflow, resultat correcte.
@;				1: hi ha overflow (resultat massa gran) i el que es
@;				   retorna s�n els bits baixos del resultat.
@;		RESULTAT -> R0 = divisi� dels dos nombres.
@;----------------------------------------------------------------
		.global exact_div_Q13
exact_div_Q13:
		push {r1 - r12, lr}
		cmp r1, #0													@; num2 == 0???
		moveq r0, #0
		moveq r4, #1												@; r4 = estat overflow = 1 (divisi� per 0).
		beq .Lcontinue
		@; Es treballar� amb valors absoluts per facilitar la tasca. Al final es modifica el resultat en cas que un dels dos sigui negatiu.
		and r10, r0, #MASK_SIGN										@; r10 = Signe de r0.
		cmp r10, #0
		rsbne r0, #0												@; abs_value(num1)
		and r11, r1, #MASK_SIGN										@; r11 = Signe de r1.
		cmp r11, #0
		rsbne r1, #0												@; abs_value(num2)
		push {r10, r11}												@; Es guarden r10 i r11 a la pila per tenir m�s registres disponibles,
																	@; ja que no cal accedir a aquests valors fins al final de la rutina.
		mov r4, #0													@; Estat overflow = 0.
		sub sp, #8													@; Es reserva espai a mem�ria pel quocient i residu per div_mod.
		mov r9, r2													@; Es guarda l'adre�a de mem�ria de l'estat d'overflow.
		mov r2, sp
		add r3, sp, #4												@; Variables locals en pila.
		mov r12, #8192												@; r12 = 2^13, codificable com a valor immediat (un �nic bit despla�at).
		umull r7, r0, r12, r0										@; num1 * 2^13. r0 = RHi, r7 = RLo
		cmp r0, #0
		beq .Lonly32												@; RHi est� buit, no cal entrar en un bucle de divisi� per un nombre de
																	@; 64 bits.
																	
		mov r10, #0													@; r10 = final_result.
		mov r5, #32													@; Es fan 32 iteracions, fins finalitzar el primer registre.
		mov r6, #0													@; �ndex bucle for, i = 1;
.Lforbig:
		cmp r1, r0
		bls .Lfinforbig
		@;Despla�ament l�gic de bits a l'esquerra del nombre de 64 bits. S'avan�a de bit en bit per controlar el fi del bucle.
		mov r0, r0, lsl #1											@; Es desplacen tots els bits amb valor de r0 a l'esquerra de tot el nombre.
		orr r0, r7, lsr #(32-1)										@; Inserci� dels bits de RLo a RHi.
		mov r7, r7, lsl #1
		add r6, #1
		b .Lforbig
.Lfinforbig:
.Lfor:
		cmp r6, r5
		bhi .Lfinfor												@; El bucle s'acaba quan i > 32.
		bl div_mod													@; Es crida a la rutina de divisi�.
		@; Preparaci� del dividend.
		ldr r0, [r3]												@; Es guarda el residu en r0.
		ldr r8, [r2]												@; Es guarda en r8 el residu.		
		@;Despla�ament l�gic de bits a l'esquerra del nombre de 64 bits. S'avan�a de bit en bit per controlar el fi del bucle.
		mov r0, r0, lsl #1											@; Es desplacen tots els bits amb valor de r0 a l'esquerra de tot el nombre.
		orr r0, r7, lsr #(32-1)										@; Inserci� dels bits de RLo a RHi.
		mov r7, r7, lsl #1											@; Es desplacen r5 bits a per tal de continuar amb la divisi�.
		@; Inserci� del quocient de la iteraci� en el resultat final.
		mov r10, r10, lsl #1										@; Es mou el resultat final r11 bits a l'esquerra per insertar el quocient.
		orr r10, r8													@; S'incorpora el quocient de la iteraci� al resultat final.
		add r6, #1													@; i++;
		b .Lfor
.Lfinfor:
		b .Lcontinue												@; Divisi� feta, es salta l'espai dedicat a la divisi� per un nombre de
																	@; 32 bits.
.Lonly32:
		mov r0, r7													@; r0 (RHi) = r7 (RLo). Necessari per crida a div_mod.
		bl div_mod													@; Es salta a la rutina div mod. Els registres tenen els valors adients.
		ldr r10, [r2]												@; Es salva el quocient en r0.
.Lcontinue:
		add sp, #8													@; Es restaura l'espai en pila.
		mov r0, r10
		pop {r10, r11}												@; Es recupera els signes de num1 i num2 originals.
		cmp r10, #0
		beq .Lresultpositive
		cmp r10, r11
		rsbeq r0, #0												@; Si Sign(num1) == Sign(num2) i Sign(num1) = negatiu, el resultat �s positiu; en cas contrari,
																	@; negatiu.
.Lresultpositive:
		strb r4, [r9]												@; Es guarda l'estat de l'overflow.
		pop {r1 - r12, pc}
.end
