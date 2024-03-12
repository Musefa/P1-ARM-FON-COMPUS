#-------------------------------------------------------------------------------
# Example Makefile to build a library and to test the functions of each module
# Authors: Santiago Romaní, Pere Millán
# Date: May 2020, March 2021, March 2022, March 2023, February 2024
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# options for code generation
#-------------------------------------------------------------------------------
ARCH	:= -march=armv5te -mlittle-endian
INCL    := -I./include
ASFLAGS	:= $(ARCH) $(INCL) -g
CCFLAGS	:= -Wall -gdwarf-3 -O0 $(ARCH) $(INCL)
LDFLAGS := -z max-page-size=0x8000 -Lp_lib

#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------
demo.elf : build/demo.o build/CelsiusFahrenheit.o 
	arm-none-eabi-ld $(LDFLAGS) build/demo.o build/CelsiusFahrenheit.o \
						p_lib/startup.o -o demo.elf

build/demo.o: source/demo.s
	arm-none-eabi-as $(ASFLAGS) source/demo.s -o build/demo.o

build/CelsiusFahrenheit.o: source/CelsiusFahrenheit.s include/Q13.i
	arm-none-eabi-as $(ASFLAGS) -c source/CelsiusFahrenheit.s -o build/CelsiusFahrenheit.o

test_CelsiusFahrenheit.elf : build/test_CelsiusFahrenheit.o build/CelsiusFahrenheit.o 
	arm-none-eabi-ld $(LDFLAGS) build/test_CelsiusFahrenheit.o build/CelsiusFahrenheit.o \
						p_lib/startup.o -o test_CelsiusFahrenheit.elf

build/test_CelsiusFahrenheit.o: tests/test_CelsiusFahrenheit.c include/CelsiusFahrenheit.h include/Q13.h
	arm-none-eabi-gcc $(CCFLAGS) -c tests/test_CelsiusFahrenheit.c -o build/test_CelsiusFahrenheit.o


#-------------------------------------------------------------------------------
# clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv build/*
	@rm -fv *.elf


#-----------------------------------------------------------------------------
# run commands
#-----------------------------------------------------------------------------
run : demo.elf
	arm-eabi-insight demo.elf &


#-----------------------------------------------------------------------------
# debug commands
#-----------------------------------------------------------------------------
debug : test_CelsiusFahrenheit.elf
	arm-eabi-insight test_CelsiusFahrenheit.elf &
