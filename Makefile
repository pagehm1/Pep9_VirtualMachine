proj3ASM: proj3.s
	arm-linux-gnueabihf-as -mthumb -o proj3.o proj3.s
	
proj3ASM_dbg: proj3.s
	arm-linux-gnueabihf-as -g -o proj3ASM_dbg.o proj3.s
	
proj3: proj3.o proj3Logic.o proj3.c
	arm-linux-gnueabihf-gcc -mthumb -o2 -o proj3 proj3.o proj3Logic.o proj3.c 
	
proj3_dbg: proj3ASM_dbg.o proj3Logic_dbg.o proj3.c
	arm-linux-gnueabihf-gcc -g -static -o2 -o proj3_dbg.o proj3ASM_dbg.o proj3.c
	
proj3Logic: proj3Logic.h proj3Logic.c
	arm-linux-gnueabihf-gcc -mthumb -o2 -o proj3Logic.o -c proj3Logic.c
	
proj3Logic_dbg: proj3Logic.h proj3Logic.c
	arm-linux-gnueabihf-gcc -g -o proj3Logic_dbg.o -c proj3Logic.c
	
clean:
	rm *.o
	rm proj3