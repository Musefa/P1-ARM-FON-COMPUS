/*----------------------------------------------------------------
|   Testing temperature data processing;
| ----------------------------------------------------------------
|	santiago.romani@urv.cat
|	pere.millan@urv.cat
|	(April 2021, March 2022, March 2023, March 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"				/* external declarations of types, defines and
								   macro for dealing with Q13 numbers */
#include "avgmaxmintemp.h"		/* mmres: return type from avgmaxmin routines */

#define NUM_TEST_ROWS	3

Q13 test_data[NUM_TEST_ROWS][12] = {
	{MAKE_Q13(13.4), MAKE_Q13(13.4), MAKE_Q13(20.0), MAKE_Q13(13.4),	// several replicated min and max
	 MAKE_Q13(20.0), MAKE_Q13(20.0), MAKE_Q13(25.9), MAKE_Q13(25.9),
	 MAKE_Q13(20.0), MAKE_Q13(20.0), MAKE_Q13(20.0), MAKE_Q13(25.9)},
	{MAKE_Q13(-2.2), MAKE_Q13(-3.5), MAKE_Q13(-5.8), MAKE_Q13(-7.5),	// all negatives
	 MAKE_Q13(-11.5), MAKE_Q13(-15.4), MAKE_Q13(-18.8), MAKE_Q13(-18.5),
	 MAKE_Q13(-14.9), MAKE_Q13(-10.3), MAKE_Q13(-5.7), MAKE_Q13(-3.0)},
	{MAKE_Q13(0.1), MAKE_Q13(0.3), MAKE_Q13(0.7), MAKE_Q13(0.8),		// all values around 0º Celsius
	 MAKE_Q13(0.8), MAKE_Q13(-0.9), MAKE_Q13(-0.7), MAKE_Q13(0.5),
	 MAKE_Q13(0.0), MAKE_Q13(0.7), MAKE_Q13(0.5), MAKE_Q13(-0.9)}
};

/* type definition of the structured record that holds the test case values */
typedef struct {
	unsigned char op;	/* type of operation ('C': by city, 'M': by month) */
	unsigned short id;	/* index to be checked (city or month) */
	Q13 xavg;			/* expected average */
	t_maxmin xmm;		/* expected max-min results */
} test_struct;

/* the list of test case values */
test_struct test_case[] =
	/* Tests for cities */
{{'C', 0, MAKE_Q13(19.8),				/*  0: several replicated min and max */
	{MAKE_Q13(13.4), MAKE_Q13(25.9),
	 MAKE_Q13(56.12), MAKE_Q13(78.62),
	 0, 6}},
 {'C', 1, MAKE_Q13(-9.8),				/*  1: all negatives */
	{MAKE_Q13(-18.8), MAKE_Q13(-2.2),
	 MAKE_Q13(-1.84), MAKE_Q13(28.04),
	 6, 0}},
 {'C', 2, MAKE_Q13(0.2),				/*  2: all values around 0º Celsius */
	{MAKE_Q13(-0.9), MAKE_Q13(0.8),
	 MAKE_Q13(30.38), MAKE_Q13(33.44),
	 5, 3}},

	/* Tests  for months */
 {'M', 0, MAKE_Q13(3.8),				/*  3: first column (January) */
	{MAKE_Q13(-2.2), MAKE_Q13(13.4),
	 MAKE_Q13(28.0), MAKE_Q13(56.1),
	 1, 0}},
 {'M', 6, MAKE_Q13(2.1),				/*  4: middle column (July) */
	{MAKE_Q13(-18.8), MAKE_Q13(25.9),
	 MAKE_Q13(-1.8), MAKE_Q13(78.6),
	 1, 0}},
 {'M', 11, MAKE_Q13(7.3),				/*  5: last column (December) */
	{MAKE_Q13(-3.0), MAKE_Q13(25.9),
	 MAKE_Q13(26.6), MAKE_Q13(78.6),
	 1, 0}}
};


unsigned int abs_value(int x) { return(x < 0 ? -x : x); }

unsigned char error_bits(Q13 avg, t_maxmin *maxmin, Q13 xavg, t_maxmin *xmm)
{
	unsigned char nerr = 0;
	unsigned int error;						/* marginal error */
	
	error = abs_value(avg - xavg);
	if (error > 2048)					/* average divergence error */
		nerr |= 1;						// set bit 0

	error = abs_value(maxmin->tmin_C - xmm->tmin_C);
	if (error > 4)						/* min temp. (ºC) divergence error */
		nerr |= 2;						// set bit 1

	error = abs_value(maxmin->tmax_C - xmm->tmax_C);
	if (error > 4)						/* max temp. (ºC) divergence error */
		nerr |= 4;						// set bit 2
	
	error = abs_value(maxmin->tmin_F - xmm->tmin_F);
	if (error > 2048)					/* min temp. (ºF) divergence error */
		nerr |= 8;						// set bit 3
	
	error = abs_value(maxmin->tmax_F - xmm->tmax_F);
	if (error > 2048)					/* max temp. (ºF) divergence error */
		nerr |= 16;						// set bit 4
	
	if (maxmin->id_min != xmm->id_min) /* min index wrong error */
		nerr |= 32;						// set bit 5
	
	if (maxmin->id_max != xmm->id_max) /* max index wrong error */
		nerr |= 64;						// set bit 6

	return(nerr);
}

int main(void)
{
	unsigned int i;						/* loop index */
	Q13 avg;							/* routine results */
	t_maxmin maxmin;
	unsigned int num_ok = 0;			/* number of right tests */
	unsigned int num_ko = 0;			/* number of wrong tests */
	unsigned int num_tests = 			/* total number of tests */
					sizeof(test_case) / sizeof(test_struct);
	unsigned char errors;

	/********* evaluate the list of test case values *********/
	for (i = 0; i < num_tests; i++)
	{
		if (test_case[i].op == 'C')
			avg = avgmaxmin_city(test_data, NUM_TEST_ROWS, test_case[i].id, &maxmin);
		else
			avg = avgmaxmin_month(test_data, NUM_TEST_ROWS, test_case[i].id, &maxmin);
		
		errors = error_bits(avg, &maxmin, test_case[i].xavg, &test_case[i].xmm);
		if ( !errors )
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
