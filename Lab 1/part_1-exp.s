.global _start

x: .word -5 		//our base
n: .word 5 	//our exponent

_start:

	LDR R0, x		//putting the address of x in R0
	LDR R1, n		//putting the address of n in R1
	BL exp		//call function exp

stop:
	B stop

exp:

	PUSH {R4}		//pushing registers we use onto the stack
	MOV R4, #1		//we will store our result in R4
	CMP R1, #0		//check if exponent is 0
	BGT expLoop		//enter loop if exponent is not 0
	MOV R0, R4		//if exponent is 0, our result will be 1, store it in R0
	POP {R4}
	BX LR		//return

expLoop:
	MUL R4, R4, R0		//multiply by our base every time we go through loop
	SUBS R1, R1, #1		//decrease exponent by 1, thus using R1 as a counter for the loop and updating condition code at the same time
	BGT expLoop		//repeat loop if R1 greater than 0 after decreasing by 1
	
	MOV R0, R4		//updating R0 with our result
	POP {R4}		//pop the register we pushed into the stack to restore initial state
	BX LR		//return

	
	