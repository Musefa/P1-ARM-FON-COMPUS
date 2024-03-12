/*----------------------------------------------------------------
|   Testing Q13 arithmetic routines;
| ----------------------------------------------------------------
|	pere.millan@urv.cat
|	santiago.romani@urv.cat
|	(Març 2021, Març 2022, Març 2023, Març 2024)
| ----------------------------------------------------------------*/

#include "Q13.h"

enum Q13_ops {add, sub, mul, div};

/* type definition of the structured record that holds the test case values */
typedef struct {
	enum Q13_ops op;	/* add / sub / mul / div */
	Q13 num1;			/* 1st input parameter of the operation */
	Q13 num2;			/* 2nd input parameter of the operation */
	Q13 result;			/* Expected result of the operation */
	unsigned char ovf;	/* Expected overflow of the operation */
} test_ops_struct;

/* the list of test case values */
test_ops_struct test_case[] =
	/* Tests operació SUMA (add) */
{{add, 0, 0, 0, 0},				/*  0: 0.0 + 0.0 = 0.0, ovflow 0 */
 {add, MAKE_Q13(1.125), 		/*  1: 1.125 + 2.5 = 3.625, ovflow 0 */
	   MAKE_Q13(2.5),
	   MAKE_Q13(3.625), 0},
 {add, MAKE_Q13(-1.125), 		/*  2: -1.125 + 2.5 = 1.375, ovflow 0 */
	   MAKE_Q13(2.5),
	   MAKE_Q13(1.375), 0},
 {add, MAKE_Q13(1.125), 		/*  3: 1.125 + -2.5 = -1.375, ovflow 0 */
	   MAKE_Q13(-2.5),
	   MAKE_Q13(-1.375), 0},
 {add, MAKE_Q13(-1.125), 		/*  4: -1.125 + -2.5 = -3.625, ovflow 0 */
	   MAKE_Q13(-2.5),
	   MAKE_Q13(-3.625), 0},
 {add, 0x12345678,				/*  5: Suma de positius amb OVERFLOW */
	   0x77777777, 
	   0x89ABCDEF, 1}, 
 {add, 0x89ABCDEF, 				/*  6: Suma de negatius amb OVERFLOW */
	   0x87654321,
	   0x11111110, 1},

	/* Tests operació RESTA (sub) */
 {sub, 0, 0, 0, 0},				/*  7: 0.0 - 0.0 = 0.0, ovflow 0 */
 {sub, MAKE_Q13(1.125), 		/*  8: 1.125 - 2.5 = -1.375, ovflow 0 */
	   MAKE_Q13(2.5),
	   MAKE_Q13(-1.375), 0},
 {sub, MAKE_Q13(-1.125), 		/*  9: -1.125 - 2.5 = -3.625, ovflow 0 */
	   MAKE_Q13(2.5),
	   MAKE_Q13(-3.625), 0},
 {sub, MAKE_Q13(1.125), 		/* 10: 1.125 - -2.5 = 3.625, ovflow 0 */
	   MAKE_Q13(-2.5),
	   MAKE_Q13(3.625), 0},
 {sub, MAKE_Q13(-1.125), 		/* 11: -1.125 - -2.5 = 1.375, ovflow 0 */
	   MAKE_Q13(-2.5),
	   MAKE_Q13(1.375), 0},
 {sub, 0x12345678, 				/* 12: Resta a positiu amb OVERFLOW */
	   0x88888889,
	   0x89ABCDEF, 1},
 {sub, 0x89ABCDEF, 				/* 13: Resta a negatiu amb OVERFLOW */
	   0x789ABCDF,
	   0x11111110, 1},

	/* Tests operació MULTIPLICACIÓ (mul) */
 {mul, 0, 0, 0, 0},				/* 14: 0.0 * 0.0 = 0.0, ovflow 0 */
 {mul, MAKE_Q13(1.125), 		/* 15: 1.125 * 2.5 = 2.8125, ovflow 0 */
	   MAKE_Q13(2.5),
	   MAKE_Q13(2.8125), 0},
 {mul, MAKE_Q13(-1.125), 		/* 16: -1.125 * 2.5 = -2.8125, ovflow 0 */
	   MAKE_Q13(2.5),
	   MAKE_Q13(-2.8125), 0},
 {mul, MAKE_Q13(1.125), 		/* 17: 1.125 * -2.5 = -2.8125, ovflow 0 */
	   MAKE_Q13(-2.5),
	   MAKE_Q13(-2.8125), 0},
 {mul, MAKE_Q13(-1.125), 		/* 18: -1.125 * -2.5 = 2.8125, ovflow 0 */
	   MAKE_Q13(-2.5),
	   MAKE_Q13(2.8125), 0},
 {mul, 0x4FFFFFFF, 				/* 19: Producte de positius amb OVERFLOW */
	   MAKE_Q13(4.0),
	   0x3FFFFFFC, 1},				/* 0x1 3FFF FFFC (overflow al bit 32) */
 {mul, 0xEDCBA988,				/* 20: Producte de negatius amb OVERFLOW */
	   MAKE_Q13(-16.0),
	   0x23456780, 1},				/* 0x1 2345 6780 (overflow al bit 32) */
 {mul, 0x40123456, 				/* 21: Producte de positius amb OVERFLOW */
	   MAKE_Q13(2.0),
	   0x802468AC, 1},				/* overflow al bit 31 */
 {mul, 0xBFEDCBAA, 				/* 22: Producte de negatius amb OVERFLOW */
	   MAKE_Q13(-2.0),
	   0x802468AC, 1},				/* overflow al bit 31 */
 {mul, 0x01000000,				/* 23: Producte positiu amb OVERFLOW total */
	   MAKE_Q13(4096.0),
	   0, 1},						/* 0x00000010 00000000 overflow a bit 36 */
 {mul, 0xFFE00000,				/* 24: Producte negatiu amb OVERFLOW total */
	   MAKE_Q13(8192.0),
	   0, 1},						/* 0xFFFFFFFC 00000000 overflow a bits 34+ */
 {mul, 0x80000000, 
		MAKE_Q13(2.0), 
		0, 1},					/* 25: Overflow al bit 32 */

	/* Tests operació DIVISIÓ (div) */
 {div, 0, 0, 0, 1},				/* 26: Div/ZERO -> 0.0, i OVERFLOW */
 {div, MAKE_Q13(123.0), 		/* 27: 123.0 / 8.0 = 15.375, ovflow 0 */
	   MAKE_Q13(8.0),
	   MAKE_Q13(15.375), 0},
 {div, MAKE_Q13(123.0), 		/* 28: 123.0 / -8.0 = -15.375, ovflow 0 */
	   MAKE_Q13(-8.0),
	   MAKE_Q13(-15.375), 0},
 {div, MAKE_Q13(-123.0), 		/* 29: -123.0 / 8.0 = -15.375, ovflow 0 */
	   MAKE_Q13(8.0),
	   MAKE_Q13(-15.375), 0},
 {div, MAKE_Q13(-123.0), 		/* 30: -123.0 / -8.0 = 15.375, ovflow 0 */
	   MAKE_Q13(-8.0),
	   MAKE_Q13(15.375), 0},
 {div, 0x1E240200, 				/* 31: Divisió de positius amb OVERFLOW */
	   MAKE_Q13(0.125),
	   0xF1201000, 1},				/* overflow al bit 31 */
 {div, 0x1E240200, 				/* 32: Divisió de positius amb OVERFLOW */
	   MAKE_Q13(0.0625),
	   0xE2402000, 1},				/* 0x1 E240 2000 (overflow als bits 31,32) */
 {div, 0xE1DBFE00, 				/* 33: Divisió de negatius amb OVERFLOW */
	   MAKE_Q13(-0.125),
	   0xF1201000, 1},				/* overflow al bit 31 */
 {div, 0x1E240200, 				/* 34: Divisió negativa amb OVERFLOW */
	   MAKE_Q13(-0.125),
	   0x0EDFF000, 1},				/* overflow als bits 31+ */
 {div, 0xE1DBFE00, 				/* 35: Divisió negativa amb OVERFLOW */
	   MAKE_Q13(0.0625),
	   0x1DBFE000, 1},				/* 0x2 1DBF E000 (overflow a bits 31+) */
 {div, 0x1E240200, 				/* 36: Divisió positiva amb OVERFLOW */
	   MAKE_Q13(0.015625),
	   0x89008000, 1},				/* 0x7 8900 8000 (overflow a bits 31+) */
 {div, 0x1E240000, 				/* 37: Divisió positiva sense overflow */
	   MAKE_Q13(128.0),
	   0x003C4800, 0}				/* 120,5625 */
};


int main(void)
{
	unsigned int i;					/* loop index */
	Q13 result;						/* routine results */
	unsigned char overflow;			/* possible overflow */
	unsigned char perf_op;			/* =1 if operation has been performed */
	unsigned int num_ops_ok = 0;	/* number of right tests (op result) */
	unsigned int num_ovf_ok = 0;	/* number of right tests (overflow result) */
	unsigned int num_tests = 		/* total number of tests */
					sizeof(test_case) / sizeof(test_ops_struct);
	int num_errors = 0;				/* number of wrong tests (result or overflow) */

	/********* evaluate the list of test case values *********/
	for (i = 0; i < num_tests; i++)
	{
		perf_op = 1;				// assume operation will be performed
		overflow = 123;				// fake value to be overwritten by routine
		switch (test_case[i].op)
		{
			case add:
				result = add_Q13(test_case[i].num1, test_case[i].num2, &overflow);
				break;
			case sub:
				result = sub_Q13(test_case[i].num1, test_case[i].num2, &overflow);
				break;
			case mul:
				result = mul_Q13(test_case[i].num1, test_case[i].num2, &overflow);
				break;
			case div:
				result = div_Q13(test_case[i].num1, test_case[i].num2, &overflow);
				break;
			default:
/* BREAKPOINT: codi operació incorrecte a test_case[i].op */
				num_errors++;
				perf_op = 0;
				break;
		}
		if (perf_op)	// evaluate return info only when operation performed
		{
			if (result == test_case[i].result)
				num_ops_ok++;
			else
/* BREAKPOINT: resultat operació incorrecte */
				num_errors++;
			
			if (overflow == test_case[i].ovf)
				num_ovf_ok++;
			else
/* BREAKPOINT: resultat overflow incorrecte */
				num_errors++;
		}
	}

/* TESTING POINT: check if number of ok tests (num_ops_ok, num_ovf_ok) 
				  is equal to number of total tests (num_tests)
				  and there ara no errors (num_errors is 0)
	(gdb) disp num_ops_ok
	(gdb) disp num_ovf_ok
	(gdb) disp num_tests
	(gdb) disp num_errors
*/

/* BREAKPOINT */
	return(0);
}
