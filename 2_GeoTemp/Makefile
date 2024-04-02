#-------------------------------------------------------------------------------
# 	MAKEFILE FASE 2 PRACTICA ARM
# 	Programador 1: eric.garcia@estudiants.urv.cat
#	Programador 2: ivan.molinero@estudiants.urv.cat
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# 	Variables de generació.
#-------------------------------------------------------------------------------
ARCH	:= -march=armv5te -mlittle-endian
INCL    := -I./include
ASFLAGS	:= $(ARCH) $(INCL) -g
CCFLAGS	:= -Wall -gdwarf-3 -O0 $(ARCH) $(INCL) -c
# A diferència de la fase 1, incloem en LDFLAGS els directoris dels arxius objecte
# externs a la tasca/fase, startup.o i CelsiusFahrenheit.o.
LDFLAGS := -z max-page-size=0x8000 -Lp_lib


#-------------------------------------------------------------------------------
#	make commands
#-------------------------------------------------------------------------------
geotemp.elf : build/avgmaxmintemp.o build/data.o build/geotemp.o
	arm-none-eabi-ld $(LDFLAGS) build/avgmaxmintemp.o build/data.o build/geotemp.o \
								p_lib/startup.o p_lib/libfoncompus.a p_lib/CelsiusFahrenheit.o -o geotemp.elf

build/avgmaxmintemp.o : source/avgmaxmintemp.s include/avgmaxmintemp.i include/Q13.i
	arm-none-eabi-as $(ASFLAGS) source/avgmaxmintemp.s -o build/avgmaxmintemp.o

build/data.o : source/data.c include/geotemp.h include/data.h include/Q13.h
	arm-none-eabi-gcc $(CCFLAGS) source/data.c -o build/data.o

build/geotemp.o : source/geotemp.c include/Q13.h include/divmod.h include/CelsiusFahrenheit.h \
				 include/avgmaxmintemp.h include/geotemp.h include/data.h
	arm-none-eabi-gcc $(CCFLAGS) source/geotemp.c -o build/geotemp.o

test_geotemp.elf : build/test_geotemp.o build/avgmaxmintemp.o
	arm-none-eabi-ld $(LDFLAGS) build/test_geotemp.o build/avgmaxmintemp.o \
								 p_lib/startup.o p_lib/libfoncompus.a p_lib/CelsiusFahrenheit.o -o test_geotemp.elf

build/test_geotemp.o : tests/test_geotemp.c include/Q13.h include/avgmaxmintemp.h
	arm-none-eabi-gcc $(CCFLAGS) tests/test_geotemp.c -o build/test_geotemp.o


#-------------------------------------------------------------------------------
# 	clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv build/*
	@rm -fv *.elf


#-----------------------------------------------------------------------------
# 	run commands
#-----------------------------------------------------------------------------
run : geotemp.elf
	arm-eabi-insight geotemp.elf &


#-----------------------------------------------------------------------------
# 	debug commands
#-----------------------------------------------------------------------------
debug : test_geotemp.elf
	arm-eabi-insight test_geotemp.elf &