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


@; Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
@;						temperatura equivalent en graus Fahrenheit, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input * 9/5) + 32.0;
	.global Celsius2Fahrenheit
Celsius2Fahrenheit:
		push {r1, r2, lr}
		smull r1, r2, r0, @;MAKE_Q13(9.0/5.0) 							@; TempC * 9/5. r1 = RdLo, r2 = RdHi
		@;mov r0, r0, asr #13 											@; Factor de conversió emprat en la multiplicació de coma fixa.
		adds r1, #32 													@; Sumem el desplaçament en l'escala Fahrenheit.
		adc r2, #0
		pop {r1, r2, pc}



@; Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
@;						temperatura equivalent en graus Celsius, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input - 32.0) * 5/9;
	.global Fahrenheit2Celsius
Fahrenheit2Celsius:
		push {lr}
		
		
		pop {pc}

.end
