.global _start
_start:
	MOV R0, #2		//R0 is our input x, setting values appropriately
	MOV R1, #10		//R1 is our input n
	PUSH {R2, LR}		//pushing R2, LR into stack as this will be changed by our method so we want to be able to restore its original state after the method
	BL exp		//branch and link to our method, update LR
	MOV R3, R0		//moving our output to R2 since we will carry out more tests otherwise value of initial test will be overwritten
	POP {R2, LR}		//restore our R2, LR from stack
	
	PUSH {R2, LR}		//pushing R2, LR into stack to store original state to be able to restore later
	MOV R0, #-5		//second test, this time for (-5)^5, R0 is still our x value
	MOV R1, #5		//R1 is our n
	BL exp		//branch to method
	POP {R2, LR}		//restoring state of R2, LR
	
stop:
	b stop


exp:
	PUSH {LR}		//store our point of return to start in the stack
	CMP R1, #0		//compare R1-0 with 0
	BEQ base_case_1		//if R1=0 we have encountered one of our base cases and we branch to our instructions for the R1=0 base case
	CMP R1, #1		//compare R1-1 with 0
	BEQ base_case_2		//if R1=1 we branch to our second base case. We don't link when we branch to base cases as we dont need to return to this point for our calculations, we want to compare values of R1 again when recursing
	
	TST R1, #1		//carrying out R1&01 and setting flags appropriately
	BGT n_odd		//if R1&01>0 that can only mean R1&01=0x001 which means R1, i.e. n is odd so we carry out the case for when n is odd
	
	MUL R0, R0, R0		//otherwise if n is even we do x=x*x to set input for next recursion
	LSR R1, R1, #1		//carry out R1>>1 to update n for next recursive call
	BL exp	//recursive call to the method, our input variables R0 and R1 have been appropriately updated in previous steps
	POP {LR}		//return 
	BX LR
	
base_case_1:		//this base case is entered when n=0
	MOV R0, #1		//we use R0 as our output as well as input, as stated in the lab document so we just simply set that as 1
	POP {LR}		//set point of return
	BX LR		//return value

base_case_2:		//base case where n=1
	POP {LR}		//in this case we are supposed to return x and R0 is already set as x so we just return
	BX LR
	
n_odd:		//this is the case when n is odd and n>1
	PUSH {R0}			//store R0 value in stack before we recurse so we can pop it out after returning
	MUL R0, R0, R0		//update R0 to what will be our input for the next recursive call, i.e. x=x*x
	LSR R1, R1, #1		//update R1 for next recursive call, i.e. n>>1
	BL exp		//recursive call but notice that we do BL so that we can return after our recursive call is finished
	POP {R2}		//we pop the value of R0 that we stored in the stack into R2
	MUL R0, R2, R0		//x*exp(x*x, n>>1) 
	POP {LR}		//return
	BX LR
	
	