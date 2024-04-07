#-------------------------------------------------------------------------------
#	MAKEFILE FASE EXTRA PRACTICA ARM
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
#	xlibQ13.a commands
#-------------------------------------------------------------------------------
xlibQ13.a : build/exactQ13.o includes/Q13.i
	arm-none-eabi-ar -rs xlibQ13.a build/exactQ13.o
	
build/exactQ13.o : source/exactQ13.s includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) source/exactQ13.s -o build/exactQ13.o

#-------------------------------------------------------------------------------
#	make commands
#-------------------------------------------------------------------------------
build/avgmaxmintemp_exact_lib.o : source/avgmaxmintemp_exact_lib.s includes/avgmaxmintemp.i includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) source/avgmaxmintemp_exact_lib.s -o build/avgmaxmintemp_exact_lib.o

build/geotemp_exact_lib.o : tests/geotemp_exact_lib.c includes/Q13.h includes/divmod.h includes/CelsiusFahrenheit.h \
				 includes/avgmaxmintemp.h includes/geotemp.h includes/data.h
	arm-none-eabi-gcc $(CCFLAGS) tests/geotemp_exact_lib.c -o build/geotemp_exact_lib.o

build/data_exact_lib.o : source/data_exact_lib.c includes/Q13.h includes/geotemp.h includes/data.h
	arm-none-eabi-gcc $(CCFLAGS) source/data_exact_lib.c -o build/data_exact_lib.o

build/CelsiusFahrenheit_exact_lib.o : source/CelsiusFahrenheit_exact_lib.s includes/Q13.i
	arm-none-eabi-as $(ASFLAGS) source/CelsiusFahrenheit_exact_lib.s -o build/CelsiusFahrenheit_exact_lib.o

build/test_geotemp_exact_lib.o : tests/test_geotemp_exact_lib.c includes/Q13.h includes/avgmaxmintemp.h
	arm-none-eabi-gcc $(CCFLAGS) tests/test_geotemp_exact_lib.c -o build/test_geotemp_exact_lib.o


#-------------------------------------------------------------------------------
#	test making commands
#-------------------------------------------------------------------------------
geotemp_exact_lib.elf : build/CelsiusFahrenheit_exact_lib.o build/geotemp_exact_lib.o build/data_exact_lib.o build/avgmaxmintemp_exact_lib.o xlibQ13.a
	arm-none-eabi-ld $(LDFLAGS) build/avgmaxmintemp_exact_lib.o build/geotemp_exact_lib.o build/data_exact_lib.o \
						tests/startup.o xlibQ13.a tests/libfoncompus.a build/CelsiusFahrenheit_exact_lib.o \
						-o geotemp_exact_lib.elf

test_geotemp_exact_lib.elf : build/CelsiusFahrenheit_exact_lib.o build/test_geotemp_exact_lib.o build/avgmaxmintemp_exact_lib.o xlibQ13.a
	arm-none-eabi-ld $(LDFLAGS) build/test_geotemp_exact_lib.o build/avgmaxmintemp_exact_lib.o \
						tests/startup.o xlibQ13.a tests/libfoncompus.a build/CelsiusFahrenheit_exact_lib.o \
						-o test_geotemp_exact_lib.elf


#-------------------------------------------------------------------------------
#	clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv build/*
	@rm -fv *.elf
	@rm -fv xlibQ13.a
	

#-----------------------------------------------------------------------------
#	run commands
#-----------------------------------------------------------------------------
run : geotemp_exact_lib.elf
	arm-eabi-insight geotemp_exact_lib.elf &
	
	
#-----------------------------------------------------------------------------
#	debug commands
#-----------------------------------------------------------------------------
debug : test_geotemp_exact_lib.elf
	arm-eabi-insight test_geotemp_exact_lib.elf &
