@;----------------------------------------------------------------
@;	"avgmaxmintemp_lib.s": adaptació de les rutines de càlcul de 
@;	valors mitjans, màxims i mínims d'una taula de temperatures, 
@;	expressades en graus Celsius o Fahrenheit, en format Q13 (coma 
@;	fixa 1:18:13) amb les rutines de libQ13.a
@;----------------------------------------------------------------
@;	Programador 1: eric.garcia@estudiants.urv.cat
@;	Programador 2: ivan.molinero@estudiants.urv.cat
@;----------------------------------------------------------------

.include "avgmaxmintemp.i"									@; Constants per facilitar l'accés a l'estructura multicamp "t_maxmin".
.include "Q13.i"

Q13_12 = 0x18000											@; Nombre 12 en Q13, necessari per avgmaxmintemp_city.

.text
		.align 2
		.arm
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
	.global avgmaxmin_city									@; Es podria canviar el nom de la rutina per tal de diferenciar.la
															@; de la de la fase 2, però com aquests arxius es cridaran per 
															@; l'assemblador juntament amb els de test, no cal fer la 
															@; diferenciació. A més, caldria modificar tots els noms de les 
															@; funcions en aquests arxius de test.
avgmaxmin_city:
		push {r1 - r12, lr}									@; Es guarden r1 i r2 perquè es fan modificacions sobre aquest regitsre per accedir a la fila id_city.
		mov r11, r0 										@; R11 = R0 = dir mem taula.
		mov r1, #12											@; Com a mul no es poden emprar valors immediats, cal fer un mov previ. Es "perd" nrows (queda a la pila) 
															@; però com no s'empra més es pot obviar aquesta pèrdua.
		mul r12, r1, r2										@; R2 = id_city * NC (12) -> es guarda en r2 el valor per accedir a aquella fila de la columna. Com al principi
															@; es fa un push i al final un pop de r2, es pot deixar així aquest valor per evitar malgastar registres
															@; i accedir de forma còmoda a la fila de la ciutat desitjada.
		ldr r0, [r11, r12, lsl #2]							@; R0 = avg = ttemp[id_city][0]. lsl #2 perquè la taula és de Q13, on cada nombre ocupa 4 bytes a memòria,
															@; per tant lsl #2 multiplica l'índex per 4 per ajustar el valor desitjat correctament.
		mov r5, #0											@; R5 = idmin = 0;
		mov r6, #0											@; R6 = idmax = 0;
		mov r7, r0											@; R7 = max = avg;
		mov r8, r0											@; R8 = min = avg;
		mov r9, #1											@; R9 = i = 1;
		sub sp, #4											@; Es reserva l'espai en memòria per la pila, per tal de poder cridar a add_Q13 dins del bucle i poder deixar l'estat
															@; de l'overflow en alguna posició de memòria, i també per la posterior crida a div_Q13.
		mov r2, sp											@; Es guarda en r2 la dir de mem per guardar l'overflow de les diferents rutines cridades de libQ13.a
.Lfor:														@; Es pot dir .Lfor perquè en la següent subrutina s'empra .Lwhile.
		add r4, r12, r9										@; R4 = id_city * NC (R2) + i (nº columna, nº mes).
		ldr r1, [r11, r4, lsl #2]							@; R1 = tvar = ttemp[id_city][i], s'obté la temperatura del mes i + 1 de la ciutat. De nou s'ha d'emprar 
															@; lsl #2 pel tema de la estructura de la memòria emprada (4 bytes per dada).
		bl add_Q13											@; avg += tvar; Gràcies a l'organització prèvia dels registres, es pot cridar directament la rutina.
		@; Condicional màxim.
		cmp r1, r7
		movgt r7, r1									@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@;Condicional mínim
		cmp r1, r8
		movlt r8, r1										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		cmp r9, #12											@; A diferència de la fase 2, aquí r1 s'empra per guardar tvar, per la crida d'add_Q13. Es pot posar #12.											
		blo .Lfor											@; i < 12 --> es continua el bucle.
@;endfor
		mov r1, #Q13_12										@; S'ha de carregar en r1 per la crida a div_Q13											
		tst r0, #MASK_SIGN									@; Signe de R0, flag Z = 0, signe positiu, flag Z = 1, signe negatiu.
		beq .Lnotminus										@; avg és positiu o negatiu ???
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_Q13											@; Llamada a rutina div_mod().
		rsb r10, r0, #0										@; avg = - avg en Ca2 (Q13). Es guarda en r10 perquè cal r0 per crides a les funcions de conversió de 
															@; temperatures.
		b .Lyetdivided										@; Es salta a l'etiqueta de divisió completada.
.Lnotminus:
		bl div_Q13
		mov r10, r0											@; R10 = avg. Es guarda en r10 perquè cal r0 per crides a les funcions de conversió de temperatures.
.Lyetdivided:
		@; El procés d'emmagatzemar valors en memòria i fer el retorn de la funció no canvia respecte amb la fase 2.
		str r8, [r3, #MM_TMINC]								@; mmres->tmin_C = min;
		str r7, [r3, #MM_TMAXC]								@; mmres->tmax_C = max;
		mov r0, r8
		bl Celsius2Fahrenheit								@; R0 = min (F)
		str r0, [r3, #MM_TMINF]								@; mmres->tmin_F = Celsius2Fahrenheit(min);
		mov r0, r7
		bl Celsius2Fahrenheit								@; R0 = max (F)
		str r0, [r3, #MM_TMAXF]								@; mmres->tmax_F = Celsius2Fahrenheit(max);
		strh r5, [r3, #MM_IDMIN]							@; mmres->id_min = idmin;
		strh r6, [r3, #MM_IDMAX]							@; mmres->id_max = idmax;
		mov r0, r10			
		add sp, #4
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
	.global avgmaxmin_month
avgmaxmin_month:
		push {lr}
		
		pop {pc}
.end
