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
	.global avgmaxmin_city									@; Es podria canviar el nom de la rutina per tal de diferenciar-la
															@; de la de la fase 2, però com aquests arxius es cridaran per 
															@; l'assemblador juntament amb els de test, no cal fer la 
															@; diferenciació. A més, caldria modificar tots els noms de les 
															@; funcions en aquests arxius de test.
avgmaxmin_city:
		push {r1 - r12, lr}									@; Es guarden r1 i r2 perquè es fan modificacions sobre aquests registres per accedir a la fila id_city i guardar
															@; la direcció de memòria necessària per poder cridar rutines de libQ13.a i emmagatzemar l'estat de l'overflow.
		mov r11, r0 										@; R11 = R0 = dir mem taula.
		mov r1, #12											@; Com a mul no es poden emprar valors immediats, cal fer un mov previ. Es "perd" nrows (queda a la pila) 
															@; però com no s'empra més es pot obviar aquesta pèrdua.
		mul r12, r1, r2										@; R12 = id_city * NC (12) -> es guarda en r12 el valor per accedir a aquella fila de la columna.
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
		movgt r7, r1										@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@; Condicional mínim.
		cmp r1, r8
		movlt r8, r1										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		cmp r9, #12											@; A diferència de la fase 2, aquí r1 s'empra per guardar tvar, per la crida d'add_Q13. Es pot posar #12 directament.											
		blo .Lfor											@; i < 12 --> es continua el bucle.
@; endfor
		mov r1, #Q13_12										@; S'ha de carregar en r1 per la crida a div_Q13											
		tst r0, #MASK_SIGN									@; Signe de R0, flag Z = 0, signe positiu, flag Z = 1, signe negatiu.
		beq .Lnotminus										@; avg és positiu o negatiu ???
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_Q13											@; Llamada a rutina div_mod().
		rsb r10, r0, #0										@; avg = - avg en Ca2 (Q13). Es guarda en r10 perquè cal r0 per crides a les funcions de conversió de 
															@; temperatures.
		b .Lyetdivided										@; Se salta a l'etiqueta de divisió completada.
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
		add sp, #4											@; Es reestableix la pila i el punter a aquesta.
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
@;
@; 		Resultat: 
@;			R0 <- temperatura mitjana, expressada en graus Celsius en format Q13.
@;-----------------------------------------------------------------------------------
	.global avgmaxmin_month
avgmaxmin_month:
		push {r1 - r11, lr}									@; Es guarden r1 i r2 perquè es fan modificacions sobre aquests registres.
		mov r11, r0 										@; R11 = R0 = dir mem taula.
		ldr r0, [r11, r2, lsl #2]							@; avg = ttemp[0][id_month]; Com fila = 0, es pot carregar la info directament amb la columna desitjada
															@; amb un desplaçament a l'esquerra de dos bits aplicat (es multiplica per 4 el nombre ja que cada 
															@; posició de la taula de Q13 ocupa 4 espais en memòria, 32 bits).														
		mov r5, #0											@; R5 = idmin = 0;
		mov r6, #0											@; R6 = idmax = 0;
		mov r7, r0											@; R7 = max = avg;
		mov r8, r0											@; R8 = min = avg;
		mov r9, #1											@; R9 = i = 1;
		mov r4, r2											@; R4 = índex d'avenç per la matriu. Comença en R4 = R2 = id_month.
		sub sp, #4											@; Es reserva l'espai en memòria per la pila, per tal de poder cridar a add_Q13 dins del bucle i poder deixar l'estat
															@; de l'overflow en alguna posició de memòria, i també per la posterior crida a div_Q13.
		mov r2, sp											@; Es guarda en r2 la dir de mem per guardar l'overflow de les diferents rutines cridades de libQ13.a
		mov r10, r1											@; Com en aquest cas si cal conservar nrows, a diferència de la rutina anterior, i es necessita r1, es 
															@; carrega nrows a R10.
.Lwhile:
		cmp r9, r10																						
		bhs .Lendwhile										@; i >= nrows --> s'acaba el bucle.		
		add r4, #12											@; S'avança per la matriu NC (una fila).
		ldr r1, [r11, r4, lsl #2]							@; R1 = tvar = ttemp[i][id_month]; De nou cal fer lsl pels 4 bytes a memòria de cada posició de la 
															@; matriu de temperatures.
		bl add_Q13											@; avg += tvar; Gràcies a l'organització prèvia dels registres, es pot cridar directament la rutina.
		@; Condicional màxim.
		cmp r1, r7
		movgt r7, r1										@; tvar > max --> max = tvar;
		movgt r6, r9										@; idmax = i;
		@; Condicional mínim
		cmp r1, r8
		movlt r8, r1										@; tvar < min --> min = tvar;
		movlt r5, r9										@; idmin = i;
		add r9, #1											@; i++;
		b .Lwhile											@; Se salta al principi del bucle while per comprovar si cal iterar o no.
.Lendwhile:
		mov r1, r10, lsl #13								@; Cal fer nrows << 13 per tal d'ajustar el valor per la divisió en Q13 (mirar documentació per justificació analítica).
															@; Es torna a carregar el valor que s'havia guardar de R10 a R1.
		tst r0, #MASK_SIGN									@; Signe de R0, flag Z = 0, signe positiu, flag Z = 1, signe negatiu.
		beq .Lnotminus1										@; avg és positiu o negatiu ???
		rsb r0, #0											@; avg = - avg en Ca2 (Q13)
		bl div_Q13											@; Llamada a rutina div_mod().
		rsb r10, r0, #0										@; avg = - avg en Ca2 (Q13). Es guarda en r10 perquè cal r0 per crides a les funcions de conversió de 
															@; temperatures.
		b .Lyetdivided1										@; Se salta a l'etiqueta de divisió completada.
.Lnotminus1:
		bl div_Q13
		mov r10, r0											@; R10 = avg. Es guarda en r10 perquè cal r0 per crides a les funcions de conversió de temperatures.
.Lyetdivided1:
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
		add sp, #4											@; Es reestableix la pila i el punter a aquesta.
		pop {r1 - r11, pc}
.end
