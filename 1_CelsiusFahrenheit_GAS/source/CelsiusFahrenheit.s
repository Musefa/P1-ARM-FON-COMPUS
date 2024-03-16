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
		
	@; PREGUNTES:
	@; 1.- Rhi simplement el perdem?
	@; 2.- Convertir número float --> Q13 (càlcul manual i implementar) ???
	@; 3.- Com emprar test_CelsiusFahrenheit.c per proves amb ensamblador ???
	@; Màscares de bits per què?

@; Celsius2Fahrenheit(): converteix una temperatura en graus Celsius a la
@;						temperatura equivalent en graus Fahrenheit, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input * 9/5) + 32.0;
	.global Celsius2Fahrenheit
Celsius2Fahrenheit:
		push {r1, r2, r3, lr}
		ldr r4, =0x0000399A												@; Necessitem 9/5 en coma fixa en un registre per poder fer la multiplicació amb smull.
		smull r1, r2, r0, r4 											@; TempC * 9/5. r1 = RdLo, r2 = RdHi
		
		mov r3, r2, lsl #19												@; Guardem en un registre temporal r3 els bits que es perdrien en realitzar un asr al Rhi (r2).
		mov r1, r1, lsr #13												@; Realitzem lsr (factor de conversió de la multiplicació) al Rlo (r1). Podríem fer un asr, però
																		@; fer un lsr ens facilita la inserció posterior dels bits del registre temporal (r3).
		orr r0, r1, r3													@; Fem un orr per afegir al registre de retorn (r0) els bits del registre temporal (r3). Podríem fer-ho
																		@; sobre r1, però com acabem retornant només r0 ja ens va bé així.
																		
		add r0, #0x00040000	 											@; Sumem el desplaçament en l'escala Fahrenheit. No cal sumar res al Rhi (r2) perquè perdrem aquesta info.
		pop {r1, r2, r3, pc}

@; Fahrenheit2Celsius(): converteix una temperatura en graus Fahrenheit a la
@;						temperatura equivalent en graus Celsius, utilitzant
@;						valors codificats en Coma Fixa 1:18:13.
@;	Entrada:
@;		input 	-> R0
@;	Sortida:
@;		R0 		-> output = (input - 32.0) * 5/9;
	.global Fahrenheit2Celsius
Fahrenheit2Celsius:
		push {r1, r2, r3, r4, lr}
		sub r0, #0x00040000												@; Restem el desplaçament en l'escala Fahrenheit.
		ldr r4, =0x000011C7												@; Necessitem 5/9 en coma fixa en un registre per poder fer la multiplicació amb smull.
		smull r1, r2, r0, r4 											@; (TempF - 32) * 5/9. r1 = RdLo, r2 = RdHi
		
		mov r3, r2, lsl #19												@; Guardem en un registre temporal r3 els bits que es perdrien en realitzar un asr al Rhi (r2).
		mov r1, r1, asr #13												@; Realitzem lsr (factor de conversió de la multiplicació) al Rlo (r1). Podríem fer un asr, però
																		@; fer un lsr ens facilita la inserció posterior dels bits del registre temporal (r3).
		orr r0, r1, r3													@; Fem un orr per afegir al registre de retorn (r0) els bits del registre temporal (r3). Podríem fer-ho
																		@; sobre r1, però com acabem retornant només r0 ja ens va bé així.
																		
		pop {r1, r2, r3, r4, pc}

.end
