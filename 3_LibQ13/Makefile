#-------------------------------------------------------------------------------
# Example Makefile to build a library and to test the functions of each module
# Authors: Santiago Romaní, Pere Millán
# Date: April 2021, March 2022, March 2023, March 2024
#-------------------------------------------------------------------------------
#	Programador/a 1: xxx.xxx@estudiants.urv.cat
#	Programador/a 2: yyy.yyy@estudiants.urv.cat
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# options for code generation
#-------------------------------------------------------------------------------
ARCH	:= -march=armv5te -mlittle-endian
INCL    := -I./includes
ASFLAGS	:= $(ARCH) $(INCL) -g
CCFLAGS	:= -Wall -gdwarf-3 -O0 $(ARCH) $(INCL)
LDFLAGS := -z max-page-size=0x8000

#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------
libQ13.a: build/Q13.o
	arm-none-eabi-ar -rs libQ13.a build/Q13.o

build/Q13.o: sources/Q13.s includes/Q13.h
	arm-none-eabi-as $(ASFLAGS) -c sources/Q13.s -o build/Q13.o


#-------------------------------------------------------------------------------
# test making commands
#-------------------------------------------------------------------------------
test_Q13.elf : tests/test_Q13.c includes/Q13.h libQ13.a
	arm-none-eabi-gcc $(CCFLAGS) -c tests/test_Q13.c -o build/test_Q13.o
	arm-none-eabi-ld $(LDFLAGS) build/test_Q13.o tests/startup.o \
					libQ13.a tests/libfoncompus.a -o test_Q13.elf

demo.elf : tests/demo.c includes/Q13.h libQ13.a
	arm-none-eabi-gcc $(CCFLAGS) -c tests/demo.c -o build/demo.o
	arm-none-eabi-ld $(LDFLAGS) build/demo.o tests/startup.o \
					libQ13.a tests/libfoncompus.a -o demo.elf


#-------------------------------------------------------------------------------
# clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv build/*
	@rm -fv *.elf
	@rm -fv libQ13.a


#-----------------------------------------------------------------------------
# run commands
#-----------------------------------------------------------------------------
run : demo.elf
	arm-eabi-insight demo.elf &


#-----------------------------------------------------------------------------
# debug commands
#-----------------------------------------------------------------------------
debug : test_Q13.elf
	arm-eabi-insight test_Q13.elf &
