/*----------------------------------------------------------------
|   Testing temperature-scale conversion routines;
| ----------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(Abril 2021, Març 2022, Març 2023, Febrer 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"				/* external declarations of types, defines and
								   macro for dealing with Q13 numbers */
#include "CelsiusFahrenheit.h"	/* external declarations of function
								   prototypes for temperature conversions */


/* type definition of the structured record that holds the test case values */
typedef struct {
	char scale;			/* letter of input scale ('C' or 'F') */
	Q13 input;			/* input temperature value for conversion */
	Q13 xresult;		/* Expected result of the operation */
} test_ops_struct;

/* the list of test case values */
test_ops_struct test_case[] =
	/* Tests Celsius -> Fahrenheit */
{{'C', MAKE_Q13(-273.15), 				/*  0: absolute min. ºC temperature */
	   MAKE_Q13(-459.67)},
 {'C', MAKE_Q13(-40.0), 				/*  1: equal ºC and ºF */
	   MAKE_Q13(-40.0)},
 {'C', MAKE_Q13(-17.7777777777778), 	/*  2: conversion to 0 ºF */
	   MAKE_Q13(0.0)},
 {'C', MAKE_Q13(-17.777), 				/*  3: nearby conversion to 0 ºF */
	   MAKE_Q13(0.0014)},
 {'C', MAKE_Q13(-17.6), 				/*  4: another nearby conversion to 0 ºF */
	   MAKE_Q13(0.32)},
 {'C', MAKE_Q13(-1.125), 				/*  5: small negative ºC (positive ºF) */
	   MAKE_Q13(29.975)},
 {'C', MAKE_Q13(0.0),					/*  6: 0.0 ºC = 32.0 ºF */
	   MAKE_Q13(32.0)},
 {'C', MAKE_Q13(1.0/(1<<13)), 			/*  7: minimal fraction in ºC */
	   MAKE_Q13(32+9.0/((1<<13)*5))},	// result = 32 + converted fract.
 {'C', MAKE_Q13(1.0), 					/*  8: unit ºC */
	   MAKE_Q13(33.8)},
 {'C', MAKE_Q13(31.1), 					/*  9: common positive ºC */
	   MAKE_Q13(87.98)},
 {'C', MAKE_Q13(4500.0), 				/* 10: large positive ºC */
	   MAKE_Q13(8132.0)},
 {'C', MAKE_Q13(145617.777), 			/* 11: max. convertable ºC */
	   MAKE_Q13(((1<<18)-1)+.999)},

	/* Tests  Fahrenheit -> Celsius */
 {'F', MAKE_Q13(-459.67), 				/* 12: absolute min. ºF temperature */
	   MAKE_Q13(-273.15)},
 {'F', MAKE_Q13(-40.0), 				/* 13: equal ºF and ºC */
	   MAKE_Q13(-40.0)},
 {'F', MAKE_Q13(-1.0/(1<<13)), 		/* 14: minimal neg. fraction in ºF */
	   MAKE_Q13(-17.777845594618056)},		// result = -17 - converted fract.
 {'F', MAKE_Q13(0.0),					/* 15: 0.0 ºF = -17.777... ºC */
	   MAKE_Q13(-17.7777777777778)},
 {'F', MAKE_Q13(1.0),					/* 16: unit ºF */
	   MAKE_Q13(-17.2222222222222)},
 {'F', MAKE_Q13(31.999), 				/* 17: small converted ºC */
	   MAKE_Q13(-0.0006)},
 {'F', MAKE_Q13(31.9997802734384), 		/* 18: small converted ºC */
	   MAKE_Q13(-0.000122070311999857)},
 {'F', MAKE_Q13(32.0), 					/* 19: 0.0 ºC */
	   MAKE_Q13(0.0)},
 {'F', MAKE_Q13(32.009), 				/* 20: small ºC */
	   MAKE_Q13(0.00500000000000019)},
 {'F', MAKE_Q13(59.0), 					/* 21: common positive ºF */
	   MAKE_Q13(15.0)},
 {'F', MAKE_Q13(451.0), 				/* 22: temperature for burning books*/
	   MAKE_Q13(232.777777777778)},
 {'F', MAKE_Q13(262143.9999), 			/* 23: max. convertable ºF */
	   MAKE_Q13(145617.7777)}
};


unsigned int abs_value(int x) { return(x < 0 ? -x : x); }
unsigned int error_margin(char scale, int expected_result);


int main(void)
{
	unsigned int i;						/* loop index */
	Q13 result;							/* routine results */
	unsigned int num_ok = 0;			/* number of right tests */
	unsigned int num_ko = 0;			/* number of wrong tests */
	unsigned int num_tests = 			/* total number of tests */
					sizeof(test_case) / sizeof(test_ops_struct);
	unsigned int abs_error, error_limit;

	/********* evaluate the list of test case values *********/
	for (i = 0; i < num_tests; i++)
	{
		if (test_case[i].scale == 'C')
			result = Celsius2Fahrenheit(test_case[i].input);
		else
			result = Fahrenheit2Celsius(test_case[i].input);
		
		abs_error = abs_value(result - test_case[i].xresult);
		error_limit = error_margin(test_case[i].scale, test_case[i].xresult);
			/* check if abs_error is under a sensible margin */
		if (abs_error <= error_limit)
			num_ok++;
		else
			num_ko++;
	}

/* TESTING POINT: check if number of ok tests 
				  is equal to number of total tests
				  or if number of ko tests is 0.
	(gdb) p num_ok
	(gdb) p num_ko
	(gdb) p num_tests
*/

/* BREAKPOINT */
	return(0);
}


/* Compute a sensible margin for absolute error of Celsius to Fahrenheit or
	Fahrenheit to Celsius transformations based on rational numbers expressed
	in Q13 format.
	Parameters:
		scale 	-> 'C' or 'F': 	'C' means Celsius to Fahrenheit and
								'F' means Fahrenheit to Celsius
		expected_result (Q13):	the expected transformed value
	Result:
		error limit, in absolute Q13 units.
*/
unsigned int error_margin(char scale, int expected_result)
{
	unsigned int result = 0;

	if (scale == 'C')
	{
			/* subtract 200.000 units to expected result, to align the zero
				crossing point of result function around 0 ºC;
			   convert negative into positive aligned results
			   shift 15 bits to the left, so as to divide corrected result by
				32.768, which is equivalent to 0.003% of expected result
				(0.003% is the relative error of representing 9/5 in Q13)
			   add 3 to give an extra amount of margin for unexpectedly high
				variations in absolute error.
			*/
		result = (abs_value(expected_result-200000) >> 15) + 3;	
	}
	else // if (scale == 'F')
	{
			/* convert negative into positive results
			   shift 12 bits to the left, so as to divide corrected result by
				4.096, which is equivalent to 0.02% of expected result
				(0.02% is the relative error of representing 5/9 in Q13)
			   add 1 to give an extra amount of margin for unexpectedly high
				variations in absolute error.
			*/
		result = (abs_value(expected_result) >> 12) + 1;
	}
	return result;
}

