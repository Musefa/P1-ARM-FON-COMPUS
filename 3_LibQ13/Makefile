#-------------------------------------------------------------------------------
# Example Makefile to build a library and to test the functions of each module
# Authors: Santiago Romaní, Pere Millán
# Date: April 2021, March 2022, March 2023, March 2024
#-------------------------------------------------------------------------------
#	Programador/a 1: eric.garcia@estudiants.urv.cat
#	Programador/a 2: ivan.molinero@estudiants.urv.cat
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#	options for code generation
#-------------------------------------------------------------------------------
ARCH	:= -march=armv5te -mlittle-endian
INCL    := -I./includes
ASFLAGS	:= $(ARCH) $(INCL) -g
CCFLAGS	:= -Wall -gdwarf-3 -O0 $(ARCH) $(INCL)
LDFLAGS := -z max-page-size=0x8000

#-------------------------------------------------------------------------------
#	libQ13 make commands
#-------------------------------------------------------------------------------
libQ13.a: build/Q13.o
	arm-none-eabi-ar -rs libQ13.a build/Q13.o

build/Q13.o: sources/Q13.s includes/Q13.h
	arm-none-eabi-as $(ASFLAGS) sources/Q13.s -o build/Q13.o

#------------------------------------------------------------------------------
#	CelsiusFahrenheit_lib make commands
#------------------------------------------------------------------------------
build/demo_CelsiusFahrenheit_lib.o: sources/demo_CelsiusFahrenheit_lib.s
	arm-none-eabi-as $(ASFLAGS) sources/demo_CelsiusFahrenheit_lib.s \
								-o build/demo_CelsiusFahrenheit_lib.o

build/CelsiusFahrenheit_lib.o: sources/CelsiusFahrenheit_lib.s includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) -c sources/CelsiusFahrenheit_lib.s -o build/CelsiusFahrenheit_lib.o

build/test_CelsiusFahrenheit_lib.o: tests/test_CelsiusFahrenheit_lib.c includes/CelsiusFahrenheit.h includes/Q13.h
	arm-none-eabi-gcc $(CCFLAGS) -c tests/test_CelsiusFahrenheit_lib.c -o build/test_CelsiusFahrenheit_lib.o

#------------------------------------------------------------------------------
#	avgmaxmintemp_lib make commands
#------------------------------------------------------------------------------
build/avgmaxmin

#-------------------------------------------------------------------------------
#	test making commands
#-------------------------------------------------------------------------------
test_Q13.elf : tests/test_Q13.c includes/Q13.h libQ13.a
	arm-none-eabi-gcc $(CCFLAGS) -c tests/test_Q13.c -o build/test_Q13.o
	arm-none-eabi-ld $(LDFLAGS) build/test_Q13.o tests/startup.o \
					libQ13.a tests/libfoncompus.a -o test_Q13.elf

demo.elf : tests/demo.c includes/Q13.h libQ13.a
	arm-none-eabi-gcc $(CCFLAGS) -c tests/demo.c -o build/demo.o
	arm-none-eabi-ld $(LDFLAGS) build/demo.o tests/startup.o \
					libQ13.a tests/libfoncompus.a -o demo.elf
					
#Cal posar com a dependència libQ13.a ja que si es modifica en el projecte s'ha de tornar a generar la llibreria estàtica.
test_CelsiusFahrenheit_lib.elf : build/test_CelsiusFahrenheit_lib.o build/CelsiusFahrenheit_lib.o libQ13.a
	arm-none-eabi-ld $(LDFLAGS) build/test_CelsiusFahrenheit_lib.o build/CelsiusFahrenheit_lib.o \
						tests/startup.o libQ13.a tests/libfoncompus.a -o test_CelsiusFahrenheit_lib.elf

#Cal posar com a dependència libQ13.a ja que si es modifica en el projecte s'ha de tornar a generar la llibreria estàtica.
demo_CelsiusFahrenheit_lib.elf : build/demo_CelsiusFahrenheit_lib.o build/CelsiusFahrenheit_lib.o libQ13.a
	arm-none-eabi-ld $(LDFLAGS) build/demo_CelsiusFahrenheit_lib.o build/CelsiusFahrenheit_lib.o \
						tests/startup.o libQ13.a tests/libfoncompus.a -o demo_CelsiusFahrenheit_lib.elf


#-------------------------------------------------------------------------------
#	clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv build/*
	@rm -fv *.elf
	@rm -fv libQ13.a


#-----------------------------------------------------------------------------
#	run commands
#-----------------------------------------------------------------------------
run : demo.elf
	arm-eabi-insight demo.elf &

run_CelsiusFahrenheit_lib : demo_CelsiusFahrenheit_lib.elf
	arm-eabi-insight demo_CelsiusFahrenheit_lib.elf &

#-----------------------------------------------------------------------------
#	debug commands
#-----------------------------------------------------------------------------
debug : test_Q13.elf
	arm-eabi-insight test_Q13.elf &

debug_CelsiusFahrenheit_lib : test_CelsiusFahrenheit_lib.elf
	arm-eabi-insight test_CelsiusFahrenheit_lib.elf &
