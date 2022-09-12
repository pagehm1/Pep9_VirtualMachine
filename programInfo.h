#ifndef PROGRAMINFO_H
#define PROGRAMINFO_H

struct programInfo
{
    int totalUnaryInstructions; //unary
	int totalnonUInstructions; //nonunary
	int totControlInstrct; //control
	int totALUInstrct; //arithmetic
	int totTrapInstrct; //trap
	int totMemInstrct;  //memory
	int immUsed;  //immediate
	int dirUsed;  //direct
	int indirUsed;  //indirect
	int stkRUsed;  //stack relative
	int stkRDUsed;  //stack-relative deferred
	int indxUsed; //indexed 
	int stkIndxUsed; //stack-indexed
	int stkdfrdIndxUsed;  //stack-deffered indexed
	int memReferences; //memory references
};

#endif