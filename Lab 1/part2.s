.global _start
array: .word 68, -22, -31, 75, -10, -61, 39, 92, 94, -55
last: .word 9

_start: 
	LDR R0, =array
	LDR R1, =array		//R1=start
	LDR R2, last
	PUSH {R4-R9, LR}
	BL quicksort
	POP {R4-R9, LR}
	
stop:
	B stop

swap:	//swap (R0, R3, R2) = swap (*array, a, b)
	PUSH {LR}
	PUSH {R7}
	PUSH {R8}
	
	//let R3 = a for swap input swap(*array, a, b)
	//R7 = temp
	LDR R7, [R0, R3, LSL#2]	//temp=array[a]	
	LDR R8, [R0, R2, LSL #2]	//R8 = array[b]
	STR R8, [R0, R3, LSL#2]	//array[a] = array [b]
	STR R7, [R0, R2, LSL#2]	//array[b] = temp
	
	POP {R8}
	POP {R7}
	POP {LR}
	BX LR

quicksort: 
	PUSH {LR}
	PUSH {R4-R10}
	
	//R4=i	,	R5=j,	R6=pivot,	R7=temp
	
	CMP R1, R2		//R1-R2
	BLT if_statement	//if R1-R2<0 or start<end
	B return
	
	if_statement:
		MOV R6, R1		//pivot=start
		MOV R4, R1		//i=start
		MOV R5, R2		//j=end
		
		while_i_less_than_j:
		
		//conditions for outer while loop
		CMP R4, R5		
		BLT inner_while_loop		//while i<j
		
		//if i>=j then while loop is not entered so we swap and carry out recursion
		//swap(*array, pivot, j)
		//push R2 into stack and replace R2 value with j(R5) and R3 value with pivot as our inputs are swap(R0, R3, R2)
		PUSH {R2}
		MOV R2, R5
		MOV R3, R6
		BL swap
		POP {R2} //restored R2 value
		
		PUSH {R2}
		PUSH {R5}
		SUB R5, R5, #1
		MOV R2, R5
		BL quicksort
		
		POP {R5}
		POP {R2}
		
		PUSH {R1}
		PUSH {R5}
		ADD R5, R5, #1
		MOV R1, R5
		BL quicksort
		POP {R5}
		POP {R1}
		
		return: 
		POP {R4-R10}
		POP {LR}
		BX LR
		
		
			inner_while_loop:	
			
			LDR R7, [R0, R4, LSL#2]		//R7=array[i]
			LDR R8, [R0, R6, LSL #2]		//R8=array[pivot]
			CMP R7, R8
			BLE second_condition	//array[i]<=array[pivot]
			B second_inner_while_condition
			second_condition:
			CMP R4, R2
			BLT first_inner_while	//i<end
			B second_inner_while_condition
			first_inner_while:
				ADD R4, R4, #1
				B inner_while_loop
				
			second_inner_while_condition:
				LDR R9, [R0, R5, LSL#2]	//R9=array[j]
				LDR R10, [R0, R6, LSL#2]	//R10=array[pivot]
				CMP R9, R10	//array[j]-array[pivot]
				BGT second_inner_while		//if array[j]>array[pivot]
				B if_i_less_than_j
				
			second_inner_while:
				SUB R5, R5, #1
				B second_inner_while_condition
			
			if_i_less_than_j:
				CMP R4, R5		//i-j
				MOV R3, R4
				BLT store_in_stack		//if i-j<0
				B while_i_less_than_j		//else start another iteration of the outer while loop
			
			store_in_stack:
				PUSH {R2}
				MOV R2, R5
				BL swap
				POP {R2}
				B while_i_less_than_j
	
	
	
	
	
	
	
	
	
	