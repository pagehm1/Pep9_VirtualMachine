#ifndef COMMANDS_H
#define COMMANDS_H

struct commands
{
    const char *instructions[39]; //string array to hold all instructions, length is 39 for the exact number of possible commands
    const char *instructType[4];  //list of all the types an instruction can be
	const char *addressType[8];  //list of all the possible addresses an instruction could use
};

void addCommands(char* list[39]);
void addTypes(char *instructType[4]);
void addAddresses(char *addressType[8]);

#endif