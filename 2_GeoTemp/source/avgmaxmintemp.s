@;----------------------------------------------------------------
@;	"avgmaxmintemp.s": rutines de càlcul de valors mitjans, màxims
@;	i mínims d'una taula de temperatures, expressades en graus
@;	Celsius o Fahrenheit, en format Q13 (coma fixa 1:18:13).
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------

@; Constants per facilitar l'accés a l'estructura multicamp "t_maxmin".
.include "avgmaxmintemp.i"
.include "Q13.i"

.text
		.align 2
		.arm
		
@; int div_mod(unsigned int num, unsigned int den,
@;				unsigned int *quo, unsigned int *mod):
@;				computes the natural division (num / den) and returns
@;				quotient and remainder (by reference); it also returns
@;				an error code, 0 -> everything OK, 1 -> division by 0
@;	Parameters:
@;		R0 -> (num) 	numerator
@;		R1 -> (den)		denominator
@;		R2 -> (* quo)	address of the variable that will hold the quotient,
@;		R3 -> (* mod)	address of the variable that will hold the remainder
@;	Results:
@; 		R0 <- returns 0 if no problem, !=0 if there is a division error (den==0)


@;-----------------------------------------------------------------------------------
@; 	avgmaxmin_city(): calcula la temperatura mitjana, màxima i mínima d'una
@;				ciutat d'una taula de temperatures, amb una fila per ciutat i
@;				una columna per mes, expressades en graus Celsius en format
@;				Q13.
@;		Paràmetres:
@;			R0 -> adreça de la taula de temperatures de 12 columnes i nrows files.
@;			R1 -> nrows, número de files de la taula.
@;			R2 -> id_city, índex de la ciutat a processar.
@;			R3 -> t_maxmin *mmres, adreça de l'estructura multicamp on es guarden
@;				  les temperatures màximes i mínimes en Celsius i Fahrenheit, així
@;				  com la posició on estan en la taula.
@;
@; 		Resultat: 
@;			R0 <- temperatura mitjana, expressada en graus Celsius en format Q13.
@;-----------------------------------------------------------------------------------

@;		R0 = avg (la suma)/ dir mem taula temp / 12
@;		R1 = nrows (possible push per optimitzar???) / dir mem cociente.
@; 		R2 = id_city / índex de fila / índex de posició / dir mem residuo.
@; 		R3 = *mmres
@; 		R4 =  / *mmres
@; 		R5 = idmin
@; 		R6 = idmax
@; 		R7 = max
@; 		R8 = min
@; 		R9 = i
@; 		R10 = tvar
@; 		R11 = *quo / index de posicio.
@; 		R12 = *res / dir mem taula. (en R0 guardem avg per passar-ho directament com a numerador a div_mod.


	.global avgmaxmin_city
avgmaxmin_city:
		push {r1 - r12, lr}									@; Es guarden r1 i r2 perquè es fan modificacions sobre aquest regitsre per accedir a la fila id_city.
		mov r12, r0 										@; R12 = R0 = dir mem taula.
		mov r1, #12											@; Com a mul no es poden emprar valors immediats, cal fer un mov previ. Es posa aquí per reaprofitar la crida a div_mod. 
															@; Es "perd" nrows (queda a la pila) però com no s'empra més es pot obviar aquesta pèrdua.
		mul r2, r1, r2										@; R2 = id_city * NC (12) -> es guarda en r2 el valor per accedir a aquella fila de la columna. Com al principi
															@; es fa un push i al final un pop de r2, es pot deixar així aquest valor per evitar malgastar registres
															@; i accedir de forma còmoda a la fila de la ciutat desitjada.
		ldr r0, [r12, r2, lsl #2]							@; R0 = avg = ttemp[id_city][0]. lsl #2 perquè la taula és de Q13, on cada nombre ocupa 4 bytes a memòria,
															@; per tant lsl #2 multiplica l'índex per 4 per ajustar el valor desitjat correctament.
		mov r5, #0											@; R5 = idmin = 0;
		mov r6, #0											@; R6 = idmax = 0;
		mov r7, r0											@; R7 = max = avg;
		mov r8, r0											@; R8 = min = avg;
		mov r9, #1											@; R9 = i = 1;
.Lfor:														@; Es pot dir .Lfor perquè en la següent subrutina s'empra .Lwhile.
		add r4, r2, r9										@; R4 = id_city * NC (R2) + i (nº columna, nº mes).
		ldr r10, [r12, r4, lsl #2]							@; R10 = tvar = ttemp[id_city][i], s'obté la temperatura del mes i + 1 de la ciutat. De nou s'ha d'emprar 
															@; lsl #2 pel tema de la estructura de la memòria emprada (4 bytes per dada).
		add r0, r10											@; avg += tvar;
		@; Condicional màxim.
		cmp r10, r7
		movgt r7, r10										@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@;Condicional mínim
		cmp r10, r8
		movlt r8, r10										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		cmp r9, r1											@; Es pot posar #12, però emprant R1 es manté una simetria amb la subrutina avgmaxmin_month.											
		blo .Lfor											@; i < 12 --> es continua el bucle.
@;endfor
		sub sp, #8											@; Es reserva espai a la pila per dos variables locals, pel quo i mod de la subrutina div_mod.
		mov r2, sp											@; R2 = dir mem cociente. Per push anterior es pot fer aquesta operació. Es perd l'índex de posició, però
															@; com no s'empra més no passa res.
		mov r4, r3											@; R4 = R3 = *mmres
		add r3, sp, #4										@; R3 = dir mem residuo. No s'empra després, però cal indicar-ho per la subrutina div_mod.
		and r10, r0, #MASK_SIGN								@; R10 = SIGNE DE R0
		cmp r10, #0											@; Si R10 = 0, R0 > 0, si no, no.
		beq .Lnotminus										@; avg és positiu o negatiu ???
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_mod											@; Llamada a rutina div_mod().
		ldr r10, [r2]										@; Es carrega de R2 la mitjana ja calculada.
		rsb r10, #0											@; avg = - avg en Ca2 (Q13)
		b .Lyetdivided										@; Es salta a l'etiqueta de divisió completada.
.Lnotminus:
		bl div_mod
		ldr r10, [r2]
.Lyetdivided:
		str r8, [r4, #MM_TMINC]								@; mmres->tmin_C = min;
		str r7, [r4, #MM_TMAXC]								@; mmres->tmax_C = max;
		mov r0, r8
		bl Celsius2Fahrenheit								@; R0 = min (F)
		str r0, [r4, #MM_TMINF]								@; mmres->tmin_F = Celsius2Fahrenheit(min);
		mov r0, r7
		bl Celsius2Fahrenheit								@; R0 = max (F)
		str r0, [r4, #MM_TMAXF]								@; mmres->tmax_F = Celsius2Fahrenheit(max);
		strh r5, [r4, #MM_IDMIN]							@; mmres->id_min = idmin;
		strh r6, [r4, #MM_IDMAX]							@; mmres->id_max = idmax;
		mov r0, r10											@; Es recupera avg per fer el retorn a R0.		
		add sp, #8											@; Es recupera l'espai a la pila per les variables locals emprades.
		pop {r1 - r12, pc}

@;-----------------------------------------------------------------------------------
@;	avgmaxmin_month(): calcula la temperatura mitjana, màxima i mínima d'un mes
@;				d'una taula de temperatures, amb una fila per ciutat i una
@;				columna per mes, expressades en graus Celsius en format Q13.
@;		Paràmetres:
@;			R0 -> adreça de la taula de temperatures de 12 columnes i nrows files.
@;			R1 -> nrows, número de files de la taula.
@;			R2 -> id_month, índex del mes a processar, [0, 11].
@;			R3 -> t_maxmin *mmres, adreça de l'estructura multicamp on es guarden
@;				  les temperatures màximes i mínimes en Celsius i Fahrenheit, així
@;				  com la posició on estan en la taula.
@;-----------------------------------------------------------------------------------

@;		R0 = dir mem taula
@;		R1 = nrows
@; 		R2 = id_month / dir mem cociente
@; 		R3 = *mmres
@; 		R4 =  / *mmres
@; 		R5 = idmin
@; 		R6 = idmax
@; 		R7 = max
@; 		R8 = min
@; 		R9 = i
@; 		R10 = tvar
@; 		R11 = NC (12, temp)
@; 		R12 = dir mem taula (en R0 guardem avg per passar-ho directament com a numerador a div_mod.

	.global avgmaxmin_month
avgmaxmin_month:
		push {r1 - r12, lr}									@; Es guarden r1 i r2 perquè es fan modificacions sobre aquest regitsre per accedir a la fila id_city.
		mov r12, r0 										@; R12 = R0 = dir mem taula.
		mov r11, #12										@; Temporalment, conté NC = 12 (mesos).
		ldr r0, [r12, r2, lsl#2]							@; avg = ttemp[0][id_month]; Com fila = 0, es pot carregar la info directament amb la columna desitjada
															@; amb un desplaçament a l'esquerra de dos bits aplicat (es multiplica per 4 el nombre ja que cada 
															@; posició de la taula de Q13 ocupa 4 espais en memòria, 32 bits).
		mov r5, #0											@; R5 = idmin = 0;
		mov r6, #0											@; R6 = idmax = 0;
		mov r7, r0											@; R7 = max = avg;
		mov r8, r0											@; R8 = min = avg;
		mov r9, #1											@; R9 = i = 1;
.Lwhile:
		cmp r9, r1																						
		bhs .Lendwhile										@; i >= nrows --> s'acaba el bucle.		
		mla r4, r9, r11, r2									@; R4 = i * NC(12) + j(id_month).
		ldr r10, [r12, r4, lsl #2]							@; R10 = tvar = ttemp[i][id_month]; De nou cal fer lsl pels 4 bytes a memòria de cada posició de la 
															@; matriu de temperatures.
		add r0, r10											@; avg += tvar;
		@; Condicional màxim.
		cmp r10, r7
		movgt r7, r10										@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@;Condicional mínim
		cmp r10, r8
		movlt r8, r10										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		b .Lwhile											@; Es salta al principi del bucle while per comprovar si cal iterar o no.
.Lendwhile:		
		sub sp, #8											@; Es reserva espai a la pila per dos variables locals, pel quo i mod de la subrutina div_mod.
		mov r2, sp											@; R2 = dir mem cociente. Per push anterior es pot fer aquesta operació. Es perd l'índex de posició, però
															@; com no s'empra més no passa res.
		mov r4, r3											@; R4 = R3 = *mmres. Es perd l'índex de matriu però no s'emprarà més.
		add r3, sp, #4										@; R3 = dir mem residuo. No s'empra després, però cal indicar-ho per la subrutina div_mod.
		and r10, r0, #MASK_SIGN								@; R10 = SIGNE DE R0
		cmp r10, #0											@; Si R10 = 0, R0 > 0, si no, no.
		beq .Lnotminus1										@; avg és positiu o negatiu ???
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_mod											@; Llamada a rutina div_mod().
		ldr r10, [r2]										@; Es carrega de R2 la mitjana ja calculada.
		rsb r10, #0											@; avg = - avg en Ca2 (Q13)
		b .Lyetdivided1										@; Es salta a l'etiqueta de divisió completada.
.Lnotminus1:
		bl div_mod
		ldr r10, [r2]
.Lyetdivided1:
		str r8, [r4, #MM_TMINC]								@; mmres->tmin_C = min;
		str r7, [r4, #MM_TMAXC]								@; mmres->tmax_C = max;
		mov r0, r8
		bl Celsius2Fahrenheit								@; R0 = min (F)
		str r0, [r4, #MM_TMINF]								@; mmres->tmin_F = Celsius2Fahrenheit(min);
		mov r0, r7
		bl Celsius2Fahrenheit								@; R0 = max (F)
		str r0, [r4, #MM_TMAXF]								@; mmres->tmax_F = Celsius2Fahrenheit(max);
		strh r5, [r4, #MM_IDMIN]							@; mmres->id_min = idmin;
		strh r6, [r4, #MM_IDMAX]							@; mmres->id_max = idmax;
		mov r0, r10											@; Es recupera avg per fer el retorn a R0.		
		add sp, #8											@; Es recupera l'espai a la pila per les variables locals emprades.
		pop {r1 - r12, pc}
.end
