#-------------------------------------------------------------------------------
#	MAKEFILE FASE 3 PRACTICA ARM
#	Programador/a 1: eric.garcia@estudiants.urv.cat
#	Programador/a 2: ivan.molinero@estudiants.urv.cat
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#	options for code generation
#-------------------------------------------------------------------------------
ARCH	:= -march=armv5te -mlittle-endian
INCL    := -I./includes
ASFLAGS	:= $(ARCH) $(INCL) -g
CCFLAGS	:= -Wall -gdwarf-3 -O0 $(ARCH) $(INCL) -c
LDFLAGS := -z max-page-size=0x8000


#-------------------------------------------------------------------------------
#	libQ13 make commands
#-------------------------------------------------------------------------------
libQ13.a: build/Q13.o includes/Q13.i
	arm-none-eabi-ar -rs libQ13.a build/Q13.o

build/Q13.o : sources/Q13.s includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) sources/Q13.s -o build/Q13.o


#------------------------------------------------------------------------------
#	CelsiusFahrenheit_lib make commands
#------------------------------------------------------------------------------
build/demo_CelsiusFahrenheit_lib.o : sources/demo_CelsiusFahrenheit_lib.s
	arm-none-eabi-as $(ASFLAGS) sources/demo_CelsiusFahrenheit_lib.s \
								-o build/demo_CelsiusFahrenheit_lib.o

build/CelsiusFahrenheit_lib.o : sources/CelsiusFahrenheit_lib.s includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) sources/CelsiusFahrenheit_lib.s -o build/CelsiusFahrenheit_lib.o

build/test_CelsiusFahrenheit_lib.o : tests/test_CelsiusFahrenheit_lib.c includes/CelsiusFahrenheit.h includes/Q13.h
	arm-none-eabi-gcc $(CCFLAGS) tests/test_CelsiusFahrenheit_lib.c -o build/test_CelsiusFahrenheit_lib.o

#------------------------------------------------------------------------------
#	avgmaxmintemp_lib make commands
#------------------------------------------------------------------------------
build/geotemp_lib.o : sources/geotemp_lib.c includes/Q13.h includes/divmod.h includes/CelsiusFahrenheit.h \
				 includes/avgmaxmintemp.h includes/geotemp.h includes/data.h
	arm-none-eabi-gcc $(CCFLAGS) sources/geotemp_lib.c -o build/geotemp_lib.o

build/avgmaxmintemp_lib.o : sources/avgmaxmintemp_lib.s includes/avgmaxmintemp.i includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) sources/avgmaxmintemp_lib.s -o build/avgmaxmintemp_lib.o

build/data_lib.o : 	sources/data_lib.c includes/Q13.h includes/geotemp.h includes/data.h
	arm-none-eabi-gcc $(CCFLAGS) sources/data_lib.c -o build/data_lib.o

build/test_geotemp_lib.o : tests/test_geotemp_lib.c includes/Q13.h includes/avgmaxmintemp.h
	arm-none-eabi-gcc $(CCFLAGS) tests/test_geotemp_lib.c -o build/test_geotemp_lib.o


#-------------------------------------------------------------------------------
#	test making commands
#-------------------------------------------------------------------------------
test_Q13.elf : tests/test_Q13.c includes/Q13.h libQ13.a
	arm-none-eabi-gcc $(CCFLAGS) tests/test_Q13.c -o build/test_Q13.o
	arm-none-eabi-ld $(LDFLAGS) build/test_Q13.o tests/startup.o \
					libQ13.a tests/libfoncompus.a -o test_Q13.elf

demo.elf : tests/demo.c includes/Q13.h libQ13.a
	arm-none-eabi-gcc $(CCFLAGS) tests/demo.c -o build/demo.o
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

#En la segona fase no calia posar CelsiusFahrenheit_lib.o com a dependència de la regla ja que era un arxiu ja obtingut
#d'un projecte extern (i que en teoria no havia de patir modificacions). No obstant, en aquesta part de la pràctica
#aquest arxiu pot modificar-se en el transcurs d'aquesta (detecció d'errors amb nous tests, per exemple), de manera que
#sí que cal incloure com a dependència.
geotemp_lib.elf : build/avgmaxmintemp_lib.o build/geotemp_lib.o build/CelsiusFahrenheit_lib.o build/data_lib.o libQ13.a
	arm-none-eabi-ld $(LDFLAGS) build/avgmaxmintemp_lib.o build/geotemp_lib.o build/data_lib.o \
						tests/startup.o libQ13.a tests/libfoncompus.a build/CelsiusFahrenheit_lib.o \
						-o geotemp_lib.elf

#Ídem de la regla anterior per aquesta regla.
test_geotemp_lib.elf : build/test_geotemp_lib.o build/avgmaxmintemp_lib.o build/CelsiusFahrenheit_lib.o libQ13.a
	arm-none-eabi-ld $(LDFLAGS) build/avgmaxmintemp_lib.o build/test_geotemp_lib.o \
								tests/startup.o libQ13.a build/CelsiusFahrenheit_lib.o tests/libfoncompus.a \
								-o test_geotemp_lib.elf


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

run_avgmaxmintemp_lib : geotemp_lib.elf
	arm-eabi-insight geotemp_lib.elf &


#-----------------------------------------------------------------------------
#	debug commands
#-----------------------------------------------------------------------------
debug : test_Q13.elf
	arm-eabi-insight test_Q13.elf &

debug_CelsiusFahrenheit_lib : test_CelsiusFahrenheit_lib.elf
	arm-eabi-insight test_CelsiusFahrenheit_lib.elf &
	
debug_avgmaxmintemp_lib : test_geotemp_lib.elf
	arm-eabi-insight test_geotemp_lib.elf &
