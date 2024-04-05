@;-----------------------------------------------------------------------
@;  Description: a program to check the temperature-scale conversion
@;				functions implemented in "CelsiusFahrenheit.c".
@;	IMPORTANT NOTE: there is a much confident testing set implemented in
@;				"tests/test_CelsiusFahrenheit.c"; the aim of "demo.s" is
@;				to show how would it be a usual main() code invoking the
@;				mentioned functions.
@;-----------------------------------------------------------------------
@;	Author: Santiago Romani (DEIM, URV)
@;	Date:   March/2022, March/2023, February/2024 
@;-----------------------------------------------------------------------
@;	Programmer 1: eric.garcia@estudiants.urv.cat
@;	Programmer 2: ivan.molinero@estudiants.urv.cat
@;-----------------------------------------------------------------------*/

.data
		.align 2
	temp1C:	.word 0x000466B8		@; temp1C = 35.21 ºC
	temp2F:	.word 0xFFFD0800		@; temp2F = -23.75 ºF

.bss
		.align 2
	temp1F:	.space 4				@; expected conversion:  95.379638671875  ºF
	temp2C:	.space 4				@; expected conversion: -30.9715576171875 ºC 


.text
		.align 2
		.arm
		.global main
main:
		push {r1, lr} 				@; No cal fer un push amb r0; és el return del main amb valor de 0.

@; temp1F = Celsius2Fahrenheit(temp1C);
		ldr r1, =temp1C				@; r1 = punter a memòria de temp1C.
		ldr r0, [r1]				@; r0 = temp1C (valor, càrrega des de memòria).
		bl Celsius2Fahrenheit		@; r0 = temp1F (valor, pel retorn de la funció Celsius2Fahreneheit).
		ldr r1, = temp1F			@; r1 = punter a memòria de temp1F. Com no s'ha d'accedir més a temp1C, 
									@; es pot reutilitzar el registre r1.
		str r0, [r1]				@; Es guarda el valor de temp1F (en r0) a la seva posició de memòria.
		
@; temp2C = Fahrenheit2Celsius(temp2F);
		ldr r1, =temp2F				@; r1 = punter a memòria de temp2F. Com no s'ha d'accedir més a temp1F,
									@; es pot reutilitzar el registre r1.
		ldr r0, [r1]				@; r0 = temp2F (valor, càrrega des de memòria).
		bl Fahrenheit2Celsius		@; r0 = temp2C (valor, pel retorn de la funció Fahrenheit2Celsius).
		ldr r1, =temp2C				@; r1 = punter a memòria de temp2C. Com no s'ha d'accedir més a temp2F,
									@; es pot reutilitzar el registre r1.
		str r0, [r1]				@; Es guarda el valor de temp2C (en r0) a la seva posició de memòria.

@; TESTING POINT: check the results
@;	(gdb) p /x temp1F		-> 0x000BEC26 
@;	(gdb) p /x temp2C		-> 0xFFFC20E9 
@; BREAKPOINT
		mov r0, #0					@; return(0)
		
		pop {r1, pc}				@; pop per recuperar els valors previs de r1 i posar el contingut del lr al
									@; pc, per produir-se el retorn de la funció. En aquest cas, sent una funció
									@; main, no es retorna a una altra posició de memòria per continuar executant
									@; instruccions.

.end

