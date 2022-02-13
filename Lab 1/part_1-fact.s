.global _start
 

_start:
	
	MOV R0, #5		//R0 will be our input variable for the method
	PUSH {R4, LR}		//pushing registers that the method will use/change
	BL fact		//branch to method
	MOV R1, R0		//put the result of our initial test in R1 to save it since we will run more tests
	POP {R4, LR}		//restore original value of registers that was stored in the stack
	
	MOV R0, #10		//2nd test, this time for 10!
	PUSH {R4, LR}		//storing original state of registers as before
	BL fact		//branch to method
	POP {R4, LR}		//restore original state from stack
	
stop:
	B stop	
	
fact:		//our method starts from fact but we first branch from factorial to store the registers we need to in the stack and to set initial values for registers we will use as variables
	PUSH {R2}		//pushing r2 as we will use this within our method as a variable
	PUSH {LR}		//pushing LR to stack to be able to return to start
	MOV R2, #1		//set R2 as 1 for our base case
	BL factorial
	POP {LR}
	POP {R2}
	BX LR
factorial:
	PUSH {LR}
	CMP R0, #2		//comparing r0-2 with 0 and set flags appropriately
	BGE rec		//branch if r0-2>=0 i.e. r0>=2
	MOV R0, R2		//if r0<2 then this is our base case, where we rerturn 1
	POP {LR}		//pop LR from stack to return, since we have reached a base case. Note that we pushed LR after R2 at the start of the method so when popping we pop LR before R2 as it is at the top of the stack
	BX LR		//return to start

rec:		//this is our recursive case, when we are not at a base case
	PUSH {R0}		//push current R0 value into stack to store it
	SUB R0, R0, #1		//reducing R0 to carry out fact(R0-1)
	BL factorial		//recursive call to our method with an updated R0 value
	POP {R3}		//put our stored R0 value into R3 by popping from the Stack
	MUL R0, R0, R3		//n*fact(n-1) where R3=n and R0=fact(n-1)
	POP {LR}		//return
	BX LR
	
	
	
	
	