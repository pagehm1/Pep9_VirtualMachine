#ifndef PEPINSTRUCTIONS_H
#define PEPINSTRUCTIONS_H

/*
Struct of instructions, their types, and the address types
*/
struct pepInstructions
{
    const char *instructions[39];  //list of all the possible instructions that the program could read
    const char *instructType[4];  //list of all the types an instruction can be
	const char *addressType[8];  //list of all the possible addresses an instruction could use
};

#endif