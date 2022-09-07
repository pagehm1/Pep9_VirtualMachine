/**********************************************************************************
 * Program Name: Instruction Decoding Simulator
 * Programmer: Hunter Page
 * Class: CSCI 2160-940
 * Project: Project 3
 * Date: 12/7/20
 * Purpose: calls an inline ADD assembly function, added comment
 *********************************************************************************/

#include "proj3Logic.h"

int inlineADD (int x, int y) {
	// this code will add together x and y, outputting to z
	int z;

	asm("ADD 	%[result], %[lhs], %[rhs]"	/* ADD x and y together, store in z */
		       : [result]"=r"	(z)		/* result from ADD stored in z */
		       : [lhs]"r"    	(x),		/* left hand operand for ADD */
			 [rhs]"r"	(y)		/* right hand operand for ADD */
		       : "cc"				/* status flags clobbered (changed) by this operation */
	);

	return z;
}