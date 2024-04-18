@;----------------------------------------------------------------
@;	"avgmaxmintemp.s": rutines de c�lcul de valors mitjans, m�xims
@;	i m�nims d'una taula de temperatures, expressades en graus
@;	Celsius o Fahrenheit, en format Q13 (coma fixa 1:18:13).
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------

.include "avgmaxmintemp.i"									@; Constants per facilitar l'acc�s a l'estructura multicamp "t_maxmin".
.include "Q13.i"

.text
		.align 2
		.arm
@; Cap�alera de la rutina div_mod (necess�ria per con�ixer els registres que calen
@; emprar pel pas de par�metres a l'hora de fer les crides).
@;-----------------------------------------------------------------------------------
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

@;-----------------------------------------------------------------------------------
@; 	avgmaxmin_city(): calcula la temperatura mitjana, m�xima i m�nima d'una
@;				ciutat d'una taula de temperatures, amb una fila per ciutat i
@;				una columna per mes, expressades en graus Celsius en format
@;				Q13.
@;		Par�metres:
@;			R0 -> adre�a de la taula de temperatures de 12 columnes i nrows files.
@;			R1 -> nrows, n�mero de files de la taula.
@;			R2 -> id_city, �ndex de la ciutat a processar.
@;			R3 -> t_maxmin *mmres, adre�a de l'estructura multicamp on es guarden
@;				  les temperatures m�ximes i m�nimes en Celsius i Fahrenheit, aix�
@;				  com la posici� on estan en la taula.
@;
@; 		Resultat: 
@;			R0 <- temperatura mitjana, expressada en graus Celsius en format Q13.
@;-----------------------------------------------------------------------------------
@;-----------------------------------------------------------------------------------
@;	LLISTA DE VALORS DELS REGISTRES EN AQUESTA RUTINA
@;	R0 -> dir mem�ria taula de temp; avg; min i max en C i F (per fer crida a 
@;		  Celsius2Fahrenheit; return d'avg final (ja calculada).
@;	R1 -> nrows (no emprat en aquesta rutina); #12 (valor immediat).
@;	R2 -> id_city; id_city * NC(12) + i; sp (dir mem quocient per div_mod).
@;	R3 -> t_maxmin *mmres; sp + 4 (dir mem residu per div_mod).
@; 	R4 -> tmaxmin *mmres
@;	R5 -> idmin
@; 	R6 -> idmax
@; 	R7 -> max
@;	R8 -> min
@; 	R9 -> i (�ndex per bucle for)
@; 	R10 -> tvar; avg calculat (despr�s de div_mod).
@;	R11 -> dir mem�ria taula de temp
@;-----------------------------------------------------------------------------------
	.global avgmaxmin_city
avgmaxmin_city:
		push {r1 - r11, lr}									@; Es guarden r1 i r2 perqu� es fan modificacions sobre aquests registres per accedir a la fila id_city.
		mov r11, r0 										@; R11 = R0 = dir mem taula.
		mov r1, #12											@; Com a mul no es poden emprar valors immediats, cal fer un mov previ. Es posa aqu� per reaprofitar la crida a div_mod. 
															@; Es "perd" nrows (realment es perd la seva possibilitat d�acc�s r�pid, el valor queda a la pila) per� com no s'empra 
															@; m�s es pot obviar aquesta p�rdua.
		mul r2, r1, r2										@; R2 = id_city * NC (12) -> es guarda en r2 el valor per accedir a aquella fila de la columna. Com al principi
															@; es fa un push i al final un pop de r2, es pot deixar aix� aquest valor per evitar malgastar registres
															@; i accedir de forma c�moda a la fila de la ciutat desitjada.
		ldr r0, [r11, r2, lsl #2]							@; R0 = avg = ttemp[id_city][0]. lsl #2 perqu� la taula �s de Q13, on cada nombre ocupa 4 bytes a mem�ria,
															@; per tant lsl #2 multiplica l'�ndex per 4 per ajustar el valor desitjat correctament.
		mov r5, #0											@; R5 = idmin = 0;
		mov r6, #0											@; R6 = idmax = 0;
		mov r7, r0											@; R7 = max = avg;
		mov r8, r0											@; R8 = min = avg;
		mov r9, #1											@; R9 = i = 1;
.Lfor:														@; Es pot dir .Lfor perqu� en la seg�ent subrutina s'empra .Lwhile.
		add r2, #1											@; R2 = �ndex d'acc�s a la matriu.
		ldr r10, [r11, r2, lsl #2]							@; R10 = tvar = ttemp[id_city][i], s'obt� la temperatura del mes (i + 1) de la ciutat. De nou s'ha d'emprar 
															@; lsl #2 pel tema de la estructura de la mem�ria emprada (4 bytes per dada).
		add r0, r10											@; avg += tvar;
		@; Condicional m�xim.
		cmp r10, r7
		movgt r7, r10										@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@; Condicional m�nim
		cmp r10, r8
		movlt r8, r10										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		cmp r9, r1											@; Es pot posar #12, per� emprant R1 es mant� una simetria amb la subrutina avgmaxmin_month.											
		blo .Lfor											@; i < 12 --> es continua el bucle.
@; endfor
		sub sp, #8											@; Es reserva espai a la pila per dos variables locals, pel quo i mod de la subrutina div_mod.
		mov r2, sp											@; R2 = dir mem quocient. Per push anterior es pot fer aquesta operaci�. Es perd l'�ndex de posici�, per�
															@; com no s'empra m�s no �s una p�rdua significativa.
		mov r4, r3											@; R4 = R3 = *mmres. Cal fer aquest moviment per poder emprar R3 com adre�a de mem�ria per res.
		add r3, sp, #4										@; R3 = dir mem res. No s'empra despr�s, per� cal indicar-ho per la subrutina div_mod.
		tst r0, #MASK_SIGN									@; Signe de R0: flag Z = 0, signe positiu, flag Z = 1, signe negatiu.
		beq .Lnotminus										@; Si avg �s positiu, es salten les instruccions de canvi de signe i directament es crida a div_mod.
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_mod											@; Llamada a rutina div_mod().
		ldr r10, [r2]										@; Es carrega de R2 la mitjana ja calculada.
		rsb r10, #0											@; avg = - avg en Ca2 (Q13)
		b .Lyetdivided										@; Se salta a l'etiqueta de divisi� completada.
.Lnotminus:
		bl div_mod											@; Llamada a rutina div_mod().
		ldr r10, [r2]										@; Es carrega de R2 la mitjana ja calculada.
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
		pop {r1 - r11, pc}

@;-----------------------------------------------------------------------------------
@;	avgmaxmin_month(): calcula la temperatura mitjana, m�xima i m�nima d'un mes
@;				d'una taula de temperatures, amb una fila per ciutat i una
@;				columna per mes, expressades en graus Celsius en format Q13.
@;		Par�metres:
@;			R0 -> adre�a de la taula de temperatures de 12 columnes i nrows files.
@;			R1 -> nrows, n�mero de files de la taula.
@;			R2 -> id_month, �ndex del mes a processar, [0, 11].
@;			R3 -> t_maxmin *mmres, adre�a de l'estructura multicamp on es guarden
@;				  les temperatures m�ximes i m�nimes en Celsius i Fahrenheit, aix�
@;				  com la posici� on estan en la taula.
@;-----------------------------------------------------------------------------------
@;-----------------------------------------------------------------------------------
@;	LLISTA DE VALORS DELS REGISTRES EN AQUESTA RUTINA
@;	R0 -> dir mem�ria taula de temp; avg; min i max en C i F (per fer crida a 
@;		  Celsius2Fahrenheit; return d'avg final (ja calculada).
@;	R1 -> nrows
@;	R2 -> id_month; �ndex d'aven� per la matriu; sp (dir mem quocient per div_mod).
@;	R3 -> t_maxmin *mmres; sp + 4 (dir mem residu per div_mod).
@; 	R4 -> tmaxmin *mmres
@;	R5 -> idmin
@; 	R6 -> idmax
@; 	R7 -> max
@;	R8 -> min
@; 	R9 -> i (�ndex per bucle for)
@; 	R10 -> tvar; avg calculat (despr�s de div_mod).
@;	R11 -> dir mem�ria taula de temp
@;-----------------------------------------------------------------------------------
	.global avgmaxmin_month
avgmaxmin_month:
		push {r2 - r11, lr}									@; Es guarda r2 perqu� es fan modificacions sobre aquest registre per poder cridar a div_mod.
		mov r11, r0 										@; R11 = R0 = dir mem taula.
		ldr r0, [r11, r2, lsl#2]							@; avg = ttemp[0][id_month]; Com fila = 0, es pot carregar la info directament amb la columna desitjada
															@; amb un despla�ament a l'esquerra de dos bits aplicat (es multiplica per 4 el nombre ja que cada 
															@; posici� de la taula de Q13 ocupa 4 espais en mem�ria, 32 bits).
		mov r5, #0											@; R5 = idmin = 0;
		mov r6, #0											@; R6 = idmax = 0;
		mov r7, r0											@; R7 = max = avg;
		mov r8, r0											@; R8 = min = avg;
		mov r9, #1											@; R9 = i = 1;
.Lwhile:
		cmp r9, r1																						
		bhs .Lendwhile										@; i >= nrows --> s'acaba el bucle.		
		add r2, #12											@; S'avan�a per la matriu NC (una fila). Queda modificat id_month, per� no es necessita despr�s.
		ldr r10, [r11, r2, lsl #2]							@; R10 = tvar = ttemp[i][id_month]; De nou cal fer lsl pels 4 bytes a mem�ria de cada posici� de la 
															@; matriu de temperatures.
		add r0, r10											@; avg += tvar;
		@; Condicional m�xim.
		cmp r10, r7
		movgt r7, r10										@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@; Condicional m�nim
		cmp r10, r8
		movlt r8, r10										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		b .Lwhile											@; Se salta al principi del bucle while per comprovar si cal iterar o no.
.Lendwhile:		
		sub sp, #8											@; Es reserva espai a la pila per dos variables locals, pel quo i mod de la subrutina div_mod.
		mov r2, sp											@; R2 = dir mem quocient. Per push anterior es pot fer aquesta operaci�. Es perd l'�ndex de posici�, per�
															@; com no s'empra m�s no �s una p�rdua significativa.
		mov r4, r3											@; R4 = R3 = *mmres. Cal fer aquest moviment per poder emprar R3 com adre�a de mem�ria per res.
		add r3, sp, #4										@; R3 = dir mem res. No s'empra despr�s, per� cal indicar-ho per la subrutina div_mod.
		tst r0, #MASK_SIGN									@; Signe de R0: flag Z = 0, signe positiu, flag Z = 1, signe negatiu.
		beq .Lnotminus1										@; avg �s positiu o negatiu ???
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_mod											@; Llamada a rutina div_mod().
		ldr r10, [r2]										@; Es carrega de R2 la mitjana ja calculada.
		rsb r10, #0											@; avg = - avg en Ca2 (Q13)
		b .Lyetdivided1										@; Se salta a l'etiqueta de divisi� completada.
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
		pop {r2 - r11, pc}
.end
