/*-----------------------------------------------------------------------
|   Description: a program to check the temperature-scale conversion
|				functions implemented in "CelsiusFahrenheit.c".
|	IMPORTANT NOTE: there is a much confident testing set implemented in
|				"tests/test_CelsiusFahrenheit.c"; the aim of "demo.c" is
|				to show how would it be a usual main() code invoking the
|				mentioned functions.
|------------------------------------------------------------------------
|	Author: Santiago Romani (DEIM, URV)
|	Date:   March/2021, February/2022 , March/2023, February/2024
| -----------------------------------------------------------------------*/

#include "Q13.h"				/* external declarations of types, defines and
								   macro for dealing with Q13 numbers */
#include "CelsiusFahrenheit.h"	/* external declarations of function
								   prototypes for temperature conversions */


/* global variables as inputs and output */
Q13 temp1C = MAKE_Q13(35.21);		// sample Celsius temperature
Q13 temp2F = MAKE_Q13(-23.75);		// sample Fahrenheit temperature

Q13 temp1F;		// expected conversion of temp1C:  95.378  ºF
Q13 temp2C;		// expected conversion of temp2C: -30.97222... ºC

int main(void)
{
	temp1F = Celsius2Fahrenheit(temp1C);
	temp2C = Fahrenheit2Celsius(temp2F);

/* TESTING POINT: check the results
	(gdb) p /f temp1F/8192.0		->  95.379638671875
	(gdb) p /f temp2C/8192.0		-> -30.9715576171875
*/

/* BREAKPOINT */
	return(0);
}
