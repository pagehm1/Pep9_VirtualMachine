/**********************************************************************************
 * Program Name: Instruction Fetch/Decoding/Execution Simulator
 * Programmer: Hunter Page
 * Class: CSCI 2160-940
 * Lab: Instruction Decoding Simulator
 * Date: 12/2/20
 * Purpose: This program is going to be repurposed to rather than fetch and decode hex code
 *          for a pep9 program, it will now execute said code and be able to read a program
 * 			either through hex or actual pep9 instructions passed in through a file. The use of 
 * 			assembly language will be removed, as I want to focus on an all-C implementation
 * 			that will create a more concise and clean program. There will be multiple 
 * 			functions planned aside from just execution. The original functionality of decoding
 * 			and displaying stats will still be present. There is also thought of adding an
 * 			editing feature that will allow the user to edit their code in the future.
 * 			Possibly using a C# interface. For now, this will work as a strict executor 
 * 			, starting with reading hex from a file. 
 **********************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "proj3Logic.h"
#include "programinfo.h"
#include "commands.h"

extern unsigned hexChecker(unsigned x, unsigned y, unsigned z);  //validates the instruction read in
extern unsigned hexConverter(unsigned x, unsigned y);	//Converts the number from ascii values to literal hex
extern unsigned instrctFnd(unsigned x, unsigned y);   //finds what instruction is being called with the converted hex
extern unsigned registerUsed(unsigned x, unsigned y); //performs shifts to find out the register used in the instruction
extern unsigned instrctType(unsigned x);   //finds what kind of instruction it is
extern unsigned addressMode(unsigned x, unsigned y);   //finds the addressing mode used in the instruction
extern int inlineADD(int x, int y);   //performs an inline add arm instruction

//holds all of the code used to collect each piece of information on the instruction and prints it out
int main(int argc, const char* argv[])
{
	struct programInfo info;
	struct commands commands;

	//add the info needed to read in pep9
	addCommands(commands.instructions);
	addAddresses(commands.instructType);
	addAddresses(commands.addressType);

	FILE* inputFile = fopen(argv[1], "r"); //sets up the input file for reading

	if(argv[1] == )
	char *hexInput = malloc(1); //location of where the user input is being stored

	printf("Please enter pep9 hex instructions, separated by one space: "); //ask use for the instructions
	
	int character; //initialize the char input
	int i = 0;  //number to iterate through the while loop
	
	//dynamically allocates to hexInput for each number read in
	//until there are no more characters
	while((character = getchar()) != '\n')
	{
		hexInput[i] = character;  //set current char equal to character
		hexInput = realloc(hexInput, i+2);  //reallocate to hexInput
		i++;
	}
	
	
	hexInput[i] = ' '; //add one more space to the array so while loop can iterate the last command
	int mnemNum;  //the number representing the instruction
	int command = 0;  //the converted number after being translated fom ascii
	int charAmount = i;  //the number of characters from the input
	i = 0;  //reset i to use to iterate through while loop
	int commandCounter = 0;  //tracks number of times iterated through so we know when to print the instruction specs
	int operand = 0;  //number representing the operand passed in with the instruction
	int commandSpec = 0;  //holds onto the command for when we are ready to print
	int commandMnem = 0;  //holds onto the mnemNum number for when we are ready to print
	int regUsed; //holds the number to represent what register was used
	char regName = ' ';  //register name holds the char representing the register used
	int instrctTypeNum = 0; //holds num representing the type of instruction the input is
	int addressNum = 0;  //integer rep of address used
	int programCounter = 0;  //integer rep of the program counter
	
	//prints the header for the results
	printf("Inst         Instruct     Addr         Program\n"); 
	printf("Spec Mnem        type Reg Mode Operand Counter\n");
	printf("---- ------- -------- --- ---- ------- -------\n");     
	
	//runs until there are no more characters passed in
	while(i <= charAmount)
	{	
		unsigned temp = (unsigned)hexInput[i];	//the first letter of the hex instruction
		unsigned temp2 = (unsigned)hexInput[i+1]; //the second letter of the hex instruction
		unsigned temp3 = (unsigned)hexInput[i+2]; //the supposed space to separate each instruction
		int hexFeedback = hexChecker(temp, temp2, temp3);  //call hexChecker to validate the instruction
		
		//if the feddback reads zero, then the instruction was bad
		if(hexFeedback == 0)
		{
			printf("There was bad input, please try again\n");
			break;
		}
		else
		{
			//convert from ascii to literal hex
			command = hexConverter(temp, temp2);
			
			//find the instruction being called
			mnemNum = instrctFnd((unsigned)command, (unsigned)commandCounter);
			
			//finding the register if unary
			if(mnemNum > 5 && mnemNum < 12)
			{
				//only if the instruction is not an operand
				if(commandCounter == 0)
				{
					//assembly method for finding the register used
					regUsed = registerUsed((unsigned)command, 1);
					
					//if returned 0, we know A was used
					if(regUsed == 0)
					{
						regName = 'A';
					}
					else
					{
						regName = 'X';
					}
				}
			}
			//finding the register if nonunary instruction
			else if(mnemNum > 28 && mnemNum < 39)
			{	
				if(commandCounter == 0)
				{	
					//assembly method for finding the register used
					regUsed = registerUsed((unsigned)command, 2);
						
					if(regUsed == 0)
					{
						regName = 'A';
					}
					else
					{
						regName = 'X';
					}
				}
			}
			
			//if the counter is 0, that means we are on the supposed instruction and not an operand
			if(commandCounter == 0)
			{
				//returns the number specifying what typ of instruction the command is
				instrctTypeNum = instrctType((unsigned)mnemNum);
				
				if(mnemNum >= 12 && mnemNum <= 21)
				{
					addressNum = addressMode((unsigned)command, 0);
					info.memReferences = inlineADD(memReferences, 1);  //increment memory reference
				}
				else if(mnemNum >= 22 && mnemNum <= 38)
				{
					addressNum = addressMode((unsigned)command, 1);
					memReferences = inlineADD(memReferences, 1);  //increment memory reference
				}
				else
				{
					addressNum = 8; //unary, no increment
				}
				
				//since command is not operand, place values into the printing variables
				commandSpec = command;
				commandMnem = mnemNum;
			}
			
			//if instruction is unary
			if(mnemNum <= 11)
			{
				//change the counter since we know there is no operand with unary 
				commandCounter = 2;
				operand = 0;
			}
			
			//if 40 is returned, the instruction was invalid
			if(mnemNum == 40)
			{
				printf("There was an invalid instruction.");
				break;
			}
			//if 41, it is an operand, so add to the operand total
			else if(mnemNum == 41)
			{
				operand += command;
			}
			
			//we are ready to print the results for the instruction
			if(commandCounter == 2)
			{
				
				printf("%02x   ", commandSpec); //print in two digits the hex value of the command
				printf("%-7s ", instructions[commandMnem]); //print the instruction
				printf("%-8s ", instructType[instrctTypeNum]); //print the instruction type 
				printf("%-3c ", regName);  //print the register used
				printf("%-4s ", addressType[addressNum]); //print the addressing type used
				
				//print space if unary
				if(mnemNum <= 11)
				{
					//increment the Unary tally
					totalUnaryInstructions = inlineADD(totalUnaryInstructions, 1);
					printf("         "); //no 
				}
				else
				{
					//print operand if nonunary
					printf("%04x     ", operand);
					totalnonUInstructions = inlineADD(totalnonUInstructions, 1); //increment nonUn tally
					
					//we should only increase the memory references if immediate addressing was not used
					//and the instruction was not a trap
					if(instrctTypeNum != 3)
					{
						memReferences = inlineADD(memReferences, 1); //increment memory reference tally
					}
				}
				//print the program counter of pep/9
				printf("%04x\n", programCounter);
				
				//increment the tally for each type of instruction
				switch(instrctTypeNum)
				{
					case 0 :
						totMemInstrct = inlineADD(totMemInstrct, 1);
						break;
					case 1 :
						totControlInstrct = inlineADD(totControlInstrct, 1);
						break;
					case 2 :
						totALUInstrct = inlineADD(totALUInstrct, 1);
						break;
					case 3 :
						totTrapInstrct = inlineADD(totTrapInstrct, 1);
						break;
					default :
						break;
				}
				
				//finding the address variable to increment
				switch(addressNum)
				{
					case 0 :
						immUsed = inlineADD(immUsed, 1);
						break;
					case 1 :
						dirUsed = inlineADD(dirUsed, 1);
						break;
					case 2 :
						indirUsed = inlineADD(indirUsed, 1);
						break;
					case 3 :
						stkRUsed = inlineADD(stkRUsed, 1);
						break;
					case 4 :
						stkRDUsed = inlineADD(stkRDUsed, 1);
						break;
					case 5 :
						indxUsed = inlineADD(indxUsed, 1);
						break;
					case 6 :
						stkIndxUsed = inlineADD(stkIndxUsed, 1);
						break;
					case 7 :
						stkdfrdIndxUsed = inlineADD(stkdfrdIndxUsed, 1);
						break;
					default :
						break;
				}
				
				//increment counter and reset some vars
				programCounter = inlineADD(programCounter, 3);
				
				//if reached STOP instruction, break out of the loop to 
				//print final tallies
				if(mnemNum == 6)
				{
					break;
				}
				
				regName = ' ';
				operand = 0;
				
			} //end if commandCounter == 2
			
			//increment counter
			commandCounter++;
			
			//reset if reached passed 2
			if(commandCounter > 2)
			{
				commandCounter = 0;
			}
			
			//increment chars being used
			i+=3;
		} //end else 
		
	} //end while i <= charAmount loop
	
	//captures total number of addresses
	int sumAddress = immUsed + dirUsed + indirUsed + stkIndxUsed + stkRUsed + stkRDUsed + stkdfrdIndxUsed + indxUsed;
	
	//captures sum of instructions
	int sumInstructions = totalUnaryInstructions + totalnonUInstructions;
	
	//prints final tallies including unary, nonunary instructions, the type of instruction
	//the addressing used, the ratio of the addressing mode used, and the total memory references
	printf("\n\n\nSummary Statistics\n");
	printf("------------------\n");
	printf("Total instructions:			%d\n\n", sumInstructions);
	printf("Unary instructions:			%d\n", totalUnaryInstructions);
	printf("Non-unary instructions:			%d\n\n", totalnonUInstructions);
	
	printf("Control flow instructions:		%d\n", totControlInstrct);
	printf("Arithmetic/logic instructions:		%d\n", totALUInstrct);
	printf("Trap Instructions:			%d\n", totTrapInstrct);
	printf("Memory Instructions:			%d\n\n", totMemInstrct);
	printf("Addressing Mode Uses\n");
	printf("--------------------\n");
	printf("Immediate:				%d (%0.5f)\n", immUsed, (float)immUsed / (float)sumAddress);
	printf("Direct:					%d (%0.5f)\n", dirUsed, (float)dirUsed / (float)sumAddress);
	printf("Indirect:				%d (%0.5f)\n", indirUsed, (float)indirUsed / (float)sumAddress);
	printf("Stack-Relative:				%d (%0.5f)\n", stkRUsed, (float)stkRUsed / (float)sumAddress);
	printf("Stack-Relative Deffered:		%d (%0.5f)\n", stkRDUsed, (float)stkRDUsed / (float)sumAddress);
	printf("Indexed:				%d (%0.5f)\n", indxUsed, (float)indxUsed / (float)sumAddress);
	printf("Stack-Indexed:				%d (%0.5f)\n", stkIndxUsed, (float)stkIndxUsed / (float)sumAddress);
	printf("Stack-deferred Indexed:			%d (%0.5f)\n\n", stkdfrdIndxUsed, (float)stkdfrdIndxUsed / (float)sumAddress);
	printf("Total memory references:		%d\n", memReferences);
	
	//free allocated space
	free(hexInput);
	return 0;
}
