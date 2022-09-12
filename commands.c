#include "commands.h"

void addCommands(char* list[39])
{
    	//unary
	list[0] = "ROR";
	list[1] = "MOVAFLG";
	list[2] = "MOVFLGA";
	list[3] = "MOVSPA";
	list[4] = "RETTR";
	list[5] = "RET";
	list[6] = "STOP";
	list[7] = "NOT";
	list[8] = "NEG";
	list[9] = "ASL";
	list[10] = "ASR";
	list[11] = "ROL";
	
	//nonunary
	list[12] = "BR";
	list[13] = "BRLE";
	list[14] = "BRLT";
	list[15] = "BREQ";
	list[16] = "BRNE";
	list[17] = "BRGE";
	list[18] = "BRGT";
	list[19] = "BRV";
	list[20] = "BRC";
	list[21] = "CALL";
	list[22] = "NOP";
	list[23] = "DECI";
	list[24] = "DECO";
	list[25] = "HEXO";
	list[26] = "STRO";
	list[27] = "ADDSP";
	list[28] = "SUBSP";
	list[29] = "ADD";
	list[30] = "SUB";
	list[31] = "AND";
	list[32] = "OR";
	list[33] = "CPW";
	list[34] = "CPB";
	list[35] = "LDW";
	list[36] = "LDB";
	list[37] = "STW";
	list[38] = "STB";
} 

void addTypes(char *instructType[4])
{
	instructType[0] = "Memory";
	instructType[1] = "Control";
	instructType[2] = "ALU";
	instructType[3] = "Trap";
}

void addAddresses(char *addressType[8])
{
	addressType[0] = "i";
	addressType[1] = "d";
	addressType[2] = "n";
	addressType[3] = "s";
	addressType[4] = "sf";
	addressType[5] = "x";
	addressType[6] = "sx";
	addressType[7] = "sfx";
	addressType[8] = "U";
}