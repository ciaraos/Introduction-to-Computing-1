	AREA	DisplayResult, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start
	LDR R4, =0			; make R4 the value of 0	
	LDR R6, =10			; make R6 the value of 10
	LDR R10, =0    		; make R10 the value of 0
	LDR R11, =9			; make R11 the value of 9

read
	BL	getkey			; read key from console
	CMP	R0, #0x0D  		; while (key != CR)
	BEQ	endRead			; {
	BL	sendchar		; echo key back to console
	
	CMP R0, #0x30		; compares R0 to 0
	BLT getOperator		; if less branches getOperator
	CMP R0, #0x39		; compares R0 to 9
	BGT getOperator		; if greater branches getOperator
	
    MUL	R4, R6, R4		; result = result x 10
	SUB	R0, R0, #0x30	; convert ASCII to numeric
	ADD	R4, R4, R0		; result = result + value	
	B	read			; branch to read
	
getOperator
	MOV	R7, R0			; give R7 the value of R0
	MOV R9, #0			; give R9 the value of 0
	B	number2			; branch to number2
	
number2
	BL	getkey			; read key from console
	CMP	R0, #0x0D  		; while (key != CR)
	BEQ	operator		; {
	BL	sendchar		; echo key back to console
	
	MUL	R9, R6, R9		; result = result x 10
	SUB	R0, R0, #0x30	; convert ASCII to numeric
	ADD	R9, R9, R0		; result = result + value		
	B	number2			; branch to number2
	
operator
	MOV R0, #0x3D		; Equals
	BL sendchar			; echo key back to console
	CMP R7, #0x2B   	; plus
	BEQ plus			; if equal branch to plus
	CMP R7, #0x2D   	; subtract
	BEQ subtract		; if equal branch to subtract
	CMP R7, #0x2A		; multiply
	BEQ multiply 		; if equal branch to multiply
	CMP R7, #0x2F	    ; Divide
	BEQ divide			; if equal branch to divide

label
	LDR R8, =1   		; make R8 the value of 1
	
display
	CMP R11, R10		; compares R11, to R10
	BEQ endLoop   		; ends loop if equal
	MUL R8, R6, R8  	; else multiplies R6 and R8
	ADD R10, R10, #1    ; adds 1 to the count
	MOV	R0, R10			; gives R0 the value of R10
	B display			; branch to display
	
endLoop
	LDR R12, =0   		; make R12 the value of 0
	
newLabel
	CMP R8, R5   		; compares R8 to R5
	BGT print   		; if greater than branches to print
	SUB R5, R5, R8 		; subtracts R8 from R5 
	ADD R12, R12, #1  	; adds 1 to the count
	B newLabel			; branch to newLabel
	
print
	MOV R6 ,#0x30   	; conveert ASCII to numeric
	ADD R6, R12, R6   	; adds R12 and R6
	MOV R0, R6 			; gives R0 the value of R6
	BL sendchar			; echo key back to console
	CMP R11, #0			; compares R11 to 0
	BEQ endRead			; if equal branch to endRead
	SUB R11, R11, #1	; subtracts 1 from R11
	B label				; branch to label

plus 
	ADD R5, R4, R9  	; adds R4 and R9 and stores in R5
	B label				; branch to label
	
multiply
	MUL R5, R4, R9		; multiplies R4 and R9 and stores in R5
	B label				; branch to label
	
subtract
	SUB R5, R4, R9		; subracts R4 from R9 and stores in R5
	B label				; branch to label

divide
	CMP R4,R9			; compares R4 to R9
	BGT endDivide		; if greater than or equal to branch
	ADD R10, R10, #1;	; add 1 to quotient
	SUB R4, R4, R9; 	; subtracts R4 from R9
	B 	divide			; branch to divide

endDivide
	MOV R5, R10			; gives R5 the valueof R10
	B label				; branch to label

endRead

stop	B	stop

	END	