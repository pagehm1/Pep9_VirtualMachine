/**********************************************************************************
 * Program Name: Instruction Decoding Simulator
 * Programmer: Hunter Page
 * Class: CSCI 2160-940
 * Project: Project 3
 * Date: 12/2/20
 * Purpose: This GNU Assembly file holds a number of global methods that include converting 
 *			ascii hex to literal hex, validating the ascii hex, finds the instruction
 *			specifier through shifting and comparing. The program also finds the 
 *			addressing mode used by the instruction (shifting), the register used (shifting), 
 *			and finds the type of instruction or if the instruction is an operand by shifting
 *			and comparing the number to preset numbers associated with an instruction
 **********************************************************************************/


.syntax unified

.text

.thumb

@validates the the suppoesed two hex digits and its space passed through

.global hexChecker	@make the method callable from the c file

hexChecker:			@takes user input of a hex instruction and validates it
	MOV	r3, #0		@set to 0 so we can keep track of which char we are comparing
	CMP	r0, #0x20   @compare the hex digit to the equivalent to a space
	BEQ	notGood		@if the hex digit is a space, that means the input passed in is not valid, and we need to return to the main program
	CMP	r1, #0x20	@compare the second hex digit to the equivalent to a space
	BEQ	notGood		@if the hex digit is a space, that means the input passed in is not valid, and we need to return to the main program
	CMP	r2, #0x20	@compare to see if the character is a space
	BNE	notGood		@if the character is not a space, then we either have a three digit hex number, or the spacing is off, so return to main
	B	charChk		@continue to check if the numbers are valid
charChk:			@checks for 0-9
	CMP	r0, #0x30	@compare the number to the ascii equivalent of 0
	BLT	notGood		@if it is anything lower, then we have invalid input
	CMP	r0, #0x39	@compare the number to the ascii equivalent of 9
	BGT	chkLtr		@if it is higher, then check if it is a letter
	CMP	r3, #1		@otherwise, check to see if this is the first or second character we are checking
	BEQ	good		@1 means the second character, so since we have validated the second char, return to main
	B	increment	@move onto next char
chkLtr:				@checks for uppercase letters
	CMP	r0, #0x41	@compare to the equivalent of 'A'
	BLT	notGood		@if anything lower, it is not valid
	CMP	r0, #0x47	@compare to the equivalent of 'F'
	BGE	lwrCase		@if higher, then could be a lowercase letter
	CMP	r3, #1		@compare to see if iterating with the second char
	BEQ	good		@if valid and second char, we can return to main
	B	increment	@if still on first char, increment to next one
lwrCase:			@checks for a lowercase number
	CMP	r0, #0x61	@compare to the equivalent of 'a'
	BLT	notGood		@if any lower, it is not valid
	CMP	r0, #0x66	@compare to the equivalent of 'f'
	BGT	notGood		@if any higher, then it is not valid
	CMP	r3, #1		@check to see if second char
	BEQ	good		@if valid and second char, we can return to main
	B	increment	@if still on first char, increment to next one
increment:			@changes the digit being checked from the first to the second
	MOV	r3, #1		@increment the counter so we know it is second char being checked
	MOV	r0, r1		@move the second digit to the first location
	B	charChk		@return back to check the second char
notGood:			@ran if the char is invalid
	MOV	r0, #0		@change feedback to main to 0 so it knows that the instruction is bad
	BX	lr			@return to main to get next input
good:				@runs if we have found twogood pieces of input
	MOV	r0, #1		@change feedback to main to 1 so it knows that the instruction is good
	BX	lr			@return to main to get next input


@converts the hex from ascii hex to literal hex value
.global hexConverter	@make the method callable from the c file

hexConverter: 		@converts the hex from ascii hex to literal hex value
	MOV	r3, #1		@places 1 so we can decrement to 0 once we run through both digits being passed in	
begin:				@begin by checking if the number is numerical
	CMP	r0, #0x39	@check to see if the number is 0-9
	BGT	uprCse		@if not check for uppercase 
	SUB	r0, #48		@if so, subtract 48 from the ascii value to get the literal value
	B	found		@go to found to either increment or return to main
uprCse:				@checking if the number is uppercase letter
	CMP	r0, #0x46	@check to see if the ascii value is 'A-F'
	BGT	lwrCse		@if not check lowercase
	SUB	r0, #55		@if so, subtract 55 to get the literal value
	B	found		@go to found to either increment or return to main
lwrCse:				@checking if the number is lowercase letter
	SUB	r0, #87		@subtract 87 to get the literal value
	B	found		@go to found to either increment or return to main
found:				@number has been found
	MOV	r4, #0x10	@move ten in so we can multiply the tens place 
	CMP	r3, #0		@compare the register to see if on the first or second digit
	BEQ	finish		@if on the second, return to main
	MUL	r0, r0, r4	@otherwise, increment the tens place
	MOV	r2, r0		@move the total so we can add to it later
	MOV	r3, #0		@decrement the counter so it knows that it is on the second digit
	MOV	r0, r1		@change the number being checked so it can increment properly
	B	begin		@return back to the top to iterate again
finish:				@we have completed converting both hex digits
	ADD	r0, r0, r2	@add them together to get the new total
	BX	lr			@return with the total


.global registerUsed	@make the method callable from the c file

registerUsed:		@finds what register was used in the instruction
	CMP	r1, #2		@if register is 2, then the instruction is nonunary, which requires a different method of solving
	BEQ	nonUnReg	@go to nonUn form of finding the register
	LSL	r0, r0, #31	@if unary, then shift 31 bits to the left to zero out entire left side of rightmost bit
	LSR	r0, r0, #31	@shift to right for easy comparison of 1 or 0
	CMP	r0, #0		@if 0, then the accumulator was used
	BEQ	accumUsed	@move to set the return value 
	MOV	r0, #1		@if 1, then index register was used, move 1 into return value
	BX	lr			@go back to main
accumUsed:			@accumulator was used
	MOV	r0, #0		@use 0 as return value to represent accumulator usage
	BX	lr			@branch back to main and return value
nonUnReg:			@nonUnary way of getting register
	LSL	r0, r0, #28	@shift left to get rid of the left side bits
	LSR	r0, r0, #31	@shift to the right 31 times to get of all bits except the fourth rightmost bit
	CMP	r0, #0		@compare to 0 to see if accumulator was used
	BEQ	accumUsed	@branch if so to return the linked value to the accumulator
	MOV	r0, #1		@otherwise, index register was used, so place 1 as reference to index
	BX	lr			@branch to main to return 1



.global instrctType	@make the method callable from the c file

instrctType:		@finds the number to represent what type of instruction was used
	CMP	r0, #6		@compare to 6 to see if the instruction specifier rep. passed in is control 
	BLE	ctrlT		@if below 6, it is a control instruction
	CMP	r0, #11		@compare to check between 7-11
	BLE	aluT		@if in between these numbers, then instruction is an arithmetic instruction
	CMP	r0, #21		@compare to check between 12-21
	BLE	ctrlT		@if in this range, then instruction is a control instruction
	CMP	r0, #26		@compare to check between 22-26
	BLE	trapT		@if in this range, then instruction is a trap
	CMP	r0, #34		@check between 27-34
	BLE	aluT		@if in this range, then instruction is an arithmetic instruction
	CMP	r0, #38		@check between 35-38
	BLE	memT		@if in this range, then instruction is a memory instruction
	MOV	r0, #4		@otherwise, something has happened that isn't supposed to, so return a number that correlates to an error
	BX	lr			@return to main with said error
ctrlT:				@returns value that correlates to a control instruction in main
	MOV	r0, #1		@move 1 to correlate in main that it is control
	BX	lr			@return to main with correlated value
trapT:				@returns value that correlates to a trap instruction in main
	MOV	r0, #3		@move 3 to correlate in main that it is trap
	BX	lr			@return to main with correlated value
aluT:				@returns value that correlates to a arithemtic instruction in main
	MOV	r0, #2		@move 2 to correlate in main that it is arithmetic
	BX	lr			@return to main with correlated value
memT:				@returns value that correlates to a memory instruction in main
	MOV	r0, #0		@move 0 to correlate in main that it is memory
	BX	lr			@return to main with correlated value


.global addressMode	@make the method callable from the c file

addressMode:		@finds what addressing mode was used and return a value that correlates to an addressing mode
	CMP	r1, #1		@compare the passed in value to 1 to see if the instruction used 1 or 3 spaces to specify the addressing mode
	BEQ	threeAddM	@if equal, it means it used three bits so a different algorithm is needed
	LSL	r0, r0, #31	@otherwise, righmost bit is used in the instruction, so shift left 31 times to clear out instruction on the left side
	LSR	r0, r0, #31	@shift to the right for easy comparison of 1
	CMP	r0, #1		@compare bit to 1 to find which mode was used
	BEQ	xAddFnd		@if so, indexed addressing was found, so go change the return value that represents indexing form
	BX	lr			@otherwise, addressing mode can only be immediate, so return the value of immediate back to main
xAddFnd:			@index addressing on singular bit addressing was found
	MOV	r0, #5		@5 is number rep of index addressing in pep9 and in this program so set 5 to be returned
	BX	lr			@return to main with return value of 5
threeAddM:			@three bits were used to represent the addressing mode used, so different algorithm is required
	LSL	r0, r0, #29	@shift 29 bits to the left to clear them out
	LSR	r0, r0, #29	@shift back to the right to get the number rep. of the addressing mode
	BX	lr			@return to main with the integer rep of the addressing mode


.global instrctFnd	@make the method callable from the c file

instrctFnd:
	MOV	r6, r0		@move the current value into register 6 to store for later
	CMP	r1, #1		@compare to see if the number passed in is an operand
	BGE	operandFnd	@if so, return a number so the program knows not to add as an instruct
unaryFind:			@first, find if the instruction is unary
	MOV	r2, #4		@move 4 so it can act as counter throughout the method
	LSR	r1, r0, #4	@shift the value to the right 4 times to isolate the section to be compared
shiftOp:			@shifts the number to check for a 1 in the 4 bits
	CMP	r2, #0		@check to see if we have already went through 4 times
	BEQ	unaryFound	@if we had no 1 in the 4 bits, then we have a unary
	SUB	r2, r2, #1	@otherwise subtract 1 from the counter
	LSR	r1, r1, #1	@shift to the right 1 so we know we can change the c-bit
	BCS	chkRotate	@if c-bit has changed, then we have a nonunary
	B	shiftOp		@if not, then iterate through the loop again
chkRotate:			@Rotate is the only unary to have 1 in the left 4 bits, so it has special case
	CMP	r6, #17		@check if it is 17, one of teh possible numbers it could be
	BGT	nonUn		@if not, then we have a nonUnary since it is not a traditional unary or rotate
	CMP	r6, #16		@check if it is 16, one of the other possible numbers
	BLT	unaryFound	@if it is less than 16, then we have a unary
	B	rorrI		@otherwise, we have a rotate instruction, so go to place to set return value for this instruction

unaryFound:			@searches through all possible unary instructions to find the correct one
	MOV 	r0, r6	@move instruction we stored at beginning back in to be compared
	CMP	r0, #5		@compare to 5 to see if it is a unary with a register
	BGT	UnWReg		@since less than 5 do no use registers, we need different algorithm to find the instruction
	CMP	r0, #5		@compare to 5 to see if instruction is movaflg
	BEQ	movaflgI	@if so, then move to designated section with return value for this command
	CMP	r0, #4		@compare to 4 to see if instruction is movflga
	BEQ	movflgaI	@if so, then move to designated section with return value for this command
	CMP	r0, #3		@compare to 3 to see if instruction is movspa
	BEQ	movspaI		@if so, then move to designated section with return value for this command
	CMP	r0, #2		@compare to 2 to see if instruction is rettr
	BEQ	rettrI		@if so, then move to designated section with return value for this command
	CMP	r0, #1		@compare to 1 to see if instruction is ret command
	BEQ	retI		@if so, then move to designated section with return value for this command
	CMP	r0, #0		@compare to 0 to see if instruction is stop command
	BEQ	stopI		@if so, then move to designated section with return value for this command
	B	noCmd		@otherwise, we have gotten a command that is not valid, so return with error
UnWReg:				@performs new shift so we can compare the values of unary instructions that use a register
	LSR	r1, r0, #1	@since we did not find an instruction that doesnt use a register, look for unary that does
	CMP	r1, #3		@that does use a register.
	BEQ	notrI		@if so, then move to designated section with return value for this command
	CMP	r1, #4		@compare to 4 to see if instruction is negr
	BEQ	negrI		@if so, then move to designated section with return value for this command
	CMP	r1, #5		@compare to 5 to see if instruction is aslr
	BEQ	aslrI		@if so, then move to designated section with return value for this command
	CMP	r1, #6		@compare to 6 to see if instruction is asrr
	BEQ	asrrI		@if so, then move to designated section with return value for this command
	CMP	r1, #7		@compare to 7 to see if instruction is rolr
	BEQ	rolrI		@if so, then move to designated section with return value for this command
	B	noCmd		@otherwise, we have gotten a command that is not valid, so return with error
nonUn:				@uses new shift to determine a nonUnary command
	MOV	r0, r6		@move origianl value into the register we are working with
	LSR	r1, r0, #1	@shift righ once since the first set of nonunary only uses the rightmost bit for register status
	CMP	r1, #18		@compare to 18 to see if instruction is bigger, which means it will need a different algorithm
	BGT	nonUn3r		@move to a three register shift-check if so
	CMP	r1, #9		@compare to 9 to see if instruction is br
	BEQ	brI			@if so, then move to designated section with return value for this command
	CMP	r1, #10		@compare to 10 to see if instruction is brle
	BEQ	brleI		@if so, then move to designated section with return value for this command
	CMP	r1, #11		@compare to 11 to see if instruction is brlt
	BEQ	brltI		@if so, then move to designated section with return value for this command
	CMP	r1, #12		@compare to 12 to see if instruction is breq
	BEQ	breqI		@if so, then move to designated section with return value for this command
	CMP	r1, #13		@compare to 13 to see if instruction is brne
	BEQ	brneI		@if so, then move to designated section with return value for this command
	CMP	r1, #14		@compare to 14 to see if instruction is brge
	BEQ	brgeI		@if so, then move to designated section with return value for this command
	CMP	r1, #15		@compare to 15 to see if instruction is brgt
	BEQ	brgtI		@if so, then move to designated section with return value for this command
	CMP	r1, #16		@compare to 16 to see if instruction is brv
	BEQ	brvI		@if so, then move to designated section with return value for this command
	CMP	r1, #17		@compare to 17 to see if instruction is brc
	BEQ	brcI		@if so, then move to designated section with return value for this command
	CMP	r1, #18		@compare to 18 to see if instruction is call
	BEQ	callI		@if so, then move to designated section with return value for this command
	B	noCmd		@otherwise, we have gotten a command that is not valid, so return with error
nonUn3r:			@performs a shift to where we can check an instruction with 3 address bits
	MOV 	r0, r6	@move original value into working register
	LSR	r1, r0, #3	@perform logical shift right to clear the address bits
	CMP	r1, #11		@check if instruction is larger, if so it will require a different algorithm to solve
	BGT	nonUn4r		@if so, move to algorithm that shifts four bits
	CMP	r1, #5		@compare to 5 to see if instruction is nop
	BEQ	nopI		@if so, then move to designated section with return value for this command
	CMP	r1, #6		@compare to 6 to see if instruction is deci
	BEQ	deciI		@if so, then move to designated section with return value for this command
	CMP	r1, #7		@compare to 7 to see if instruction is deco
	BEQ	decoI		@if so, then move to designated section with return value for this command
	CMP	r1, #8		@compare to 8 to see if instruction is hexo
	BEQ	hexoI		@if so, then move to designated section with return value for this command
	CMP	r1, #9		@compare to 9 to see if instruction is stro
	BEQ	stroI		@if so, then move to designated section with return value for this command
	CMP	r1, #10		@compare to 10 to see if instruction is addsp
	BEQ	addspI		@if so, then move to designated section with return value for this command
	CMP	r1, #11		@compare to 11 to see if instruction is subsp
	BEQ	subspI		@if so, then move to designated section with return value for this command
	B	noCmd		@otherwise, we have gotten a command that is not valid, so return with error
nonUn4r:			@performs shift to clear the four righmost bits, which hold the addressing mode and register
	MOV	r0, r6		@move original value into working register to reset from previous iteration
	LSR	r1, r0, #4	@shift to clear the addressing mode and register bits
	CMP	r1, #15		@compare to 15, and if it is greater, then we have an invalid instruction
	BGT	noCmd		@move to command that will return an invalid address
	CMP	r1, #6		@compare to 6 to see if instruction is addr
	BEQ	addrI		@if so, then move to designated section with return value for this command
	CMP	r1, #7		@compare to 7 to see if instruction is subr
	BEQ	subrI		@if so, then move to designated section with return value for this command
	CMP	r1, #8		@compare to 8 to see if instruction is andr
	BEQ	andrI		@if so, then move to designated section with return value for this command
	CMP	r1, #9		@compare to 9 to see if instruction is orr
	BEQ	orrI		@if so, then move to designated section with return value for this command
	CMP	r1, #10		@compare to 10 to see if instruction is cpwr
	BEQ	cpwrI		@if so, then move to designated section with return value for this command
	CMP	r1, #11		@compare to 11 to see if instruction is cpbr
	BEQ	cpbrI		@if so, then move to designated section with return value for this command
	CMP	r1, #12		@compare to 12 to see if instruction is ldwr
	BEQ	ldwrI		@if so, then move to designated section with return value for this command
	CMP	r1, #13		@compare to 13 to see if instruction is deci
	BEQ	ldbrI		@if so, then move to designated section with return value for this command
	CMP	r1, #14		@compare to 14 to see if instruction is stwr
	BEQ	stwrI		@if so, then move to designated section with return value for this command
	CMP	r1, #15		@compare to 15 to see if instruction is stbr
	BEQ	stbrI		@if so, then move to designated section with return value for this command
	B	noCmd		@otherwise, we have gotten a command that is not valid, so return with error
noCmd:				@the command used if an instruction was invalid
	MOV	r0, #40		@40 is he number used in main to signify an invalid intruction
	BX	lr			@return that value back to main			

@Unary instruction return values
rorrI:				@the return section for rorr
	MOV	r0, #0		@0 is the retun value for rorr
	BX	lr			@branch back to main with return value of the instruction
movaflgI:			@the return section for movaflg
	MOV	r0, #1		@1 is the retun value for movaflg
	BX	lr			@branch back to main with return value of the instruction
movflgaI:			@the return section for movflga
	MOV	r0, #2		@2 is the retun value for movflga
	BX	lr			@branch back to main with return value of the instruction
movspaI:			@the return section for movspa
	MOV	r0, #3		@3 is the retun value for movspa
	BX	lr			@branch back to main with return value of the instruction
rettrI:				@the return section for rettr
	MOV	r0, #4		@4 is the retun value for rettr
	BX	lr			@branch back to main with return value of the instruction
retI:				@the return section for ret
	MOV	r0, #5		@5 is the retun value for ret
	BX	lr			@branch back to main with return value of the instruction
stopI:				@the return section for stop
	MOV	r0, #6		@6 is the retun value for stop
	BX	lr			@branch back to main with return value of the instruction
notrI:				@the return section for notr
	MOV	r0, #7		@7 is the retun value for notr
	BX	lr			@branch back to main with return value of the instruction
negrI:				@the return section for negr
	MOV	r0, #8		@8 is the retun value for negr
	BX	lr			@branch back to main with return value of the instruction
aslrI:				@the return section for aslr
	MOV	r0, #9		@9 is the retun value for aslr
	BX	lr			@branch back to main with return value of the instruction
asrrI:				@the return section for asrr
	MOV	r0, #10		@10 is the retun value for asrr
	BX	lr			@branch back to main with return value of the instruction
rolrI:				@the return section for rolr
	MOV	r0, #11		@11 is the retun value for rolr
	BX	lr			@branch back to main with return value of the instruction

@nonunary instruction return values
brI:				@the return section for br
	MOV	r0, #12		@12 is the retun value for br
	BX	lr			@branch back to main with return value of the instruction
brleI:				@the return section for brle
	MOV	r0, #13		@13 is the retun value for brle
	BX	lr			@branch back to main with return value of the instruction
brltI:				@the return section for brlt
	MOV	r0, #14		@14 is the retun value for brlt
	BX	lr			@branch back to main with return value of the instruction
breqI:				@the return section for breq
	MOV	r0, #15		@15 is the retun value for breq
	BX	lr			@branch back to main with return value of the instruction
brneI:				@the return section for brne
	MOV	r0, #16		@16 is the retun value for brne
	BX	lr			@branch back to main with return value of the instruction
brgeI:				@the return section for breq
	MOV	r0, #17		@17 is the retun value for breq
	BX	lr			@branch back to main with return value of the instruction
brgtI:				@the return section for brgt
	MOV	r0, #18		@18 is the retun value for brgt
	BX	lr			@branch back to main with return value of the instruction
brvI:				@the return section for brv
	MOV	r0, #19		@19 is the retun value for brv
	BX	lr			@branch back to main with return value of the instruction
brcI:				@the return section for brc
	MOV	r0, #20		@20 is the retun value for brc
	BX	lr			@branch back to main with return value of the instruction
callI:				@the return section for call
	MOV	r0, #21		@21 is the retun value for call
	BX	lr			@branch back to main with return value of the instruction
nopI:				@the return section for nop
	MOV	r0, #22		@22 is the retun value for nop
	BX	lr			@branch back to main with return value of the instruction
deciI:				@the return section for deci
	MOV	r0, #23		@23 is the retun value for deci
	BX	lr			@branch back to main with return value of the instruction
decoI:				@the return section for deco
	MOV	r0, #24		@24 is the retun value for deco
	BX	lr			@branch back to main with return value of the instruction
hexoI:				@the return section for hexo
	MOV	r0, #25		@25 is the retun value for hexo
	BX	lr			@branch back to main with return value of the instruction
stroI:				@the return section for stro
	MOV	r0, #26		@26 is the retun value for stro
	BX	lr			@branch back to main with return value of the instruction
addspI:				@the return section for addsp
	MOV	r0, #27		@27 is the retun value for addsp
	BX	lr			@branch back to main with return value of the instruction
subspI:				@the return section for subsp
	MOV	r0, #28		@28 is the retun value for subsp
	BX	lr			@branch back to main with return value of the instruction
addrI:				@the return section for addr
	MOV	r0, #29		@29 is the retun value for addr
	BX	lr			@branch back to main with return value of the instruction
subrI:				@the return section for subr
	MOV	r0, #30		@30 is the retun value for subr
	BX	lr			@branch back to main with return value of the instruction
andrI:				@the return section for andr
	MOV	r0, #31		@31 is the retun value for andr
	BX	lr			@branch back to main with return value of the instruction
orrI:				@the return section for orr
	MOV	r0, #32		@32 is the retun value for orr
	BX	lr			@branch back to main with return value of the instruction
cpwrI:				@the return section for cpwr
	MOV	r0, #33		@33 is the retun value for cpwr
	BX	lr			@branch back to main with return value of the instruction
cpbrI:				@the return section for cpbr
	MOV	r0, #34		@34 is the retun value for cpbr
	BX	lr			@branch back to main with return value of the instruction
ldwrI:				@the return section for ldwr
	MOV	r0, #35		@35 is the retun value for ldwr
	BX	lr			@branch back to main with return value of the instruction
ldbrI:				@the return section for ldbr
	MOV	r0, #36		@36 is the retun value for ldbr
	BX	lr			@branch back to main with return value of the instruction
stwrI:				@the return section for stwr
	MOV	r0, #37		@37 is the retun value for stwr
	BX	lr			@branch back to main with return value of the instruction
stbrI:				@the return section for stbr
	MOV	r0, #38		@38 is the retun value for stbr
	BX	lr			@branch back to main with return value of the instruction
operandFnd:			@the return section for an operand that had been found
	MOV	r0, #41		@41 is the retun value for an operand
	BX	lr			@branch back to main with return value of the instruction

.end				@end the assembly file
