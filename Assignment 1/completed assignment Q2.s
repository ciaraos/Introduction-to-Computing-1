	AREA	ExpEval, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8

start
	LDR R4, =0			; make R4 the value of 0	
	LDR R6, =10			; make R6 the value of 10
	LDR R10, =0			; make R10 the value of 0

read
	BL	getkey			; read key from console
	CMP	R0, #0x0D  		; while (key != CR)
	BEQ	endRead			; {
	BL	sendchar		; echo key back to console
		
	CMP R0, #0x30		; compare R0 to 0
	BLT getOperator		; if less than branch to getOperator
	CMP R0, #0x39		; compare R0 to 9
	BGT getOperator		; if greater than branch to getOperator
	
    MUL	R4, R6, R4		; result = result x 10
	SUB	R0, R0, #0x30	; convert ASCII to numeric
	ADD	R4, R4, R0		; result = result + value	
	B	read			; branch to read
	
getOperator
	MOV	R7, R0;			; give R7 the value of R0
	MOV R9, #0;			; give R9 the value of 0
	B	number2			; branch to number2
	
number2
	BL	getkey			; read key from console
	CMP	R0, #0x0D  		; while (key != CR)
	BEQ	operator		; {
	BL	sendchar		; echo key back to console
	
	MUL	R9, R6, R9		; result = result x 10
	SUB	R0, R0, #0x30	; convert ASCII to numeric
	ADD	R9, R0, R9		; result = result + value		
	B	number2			; branch to number 2
	
operator
	CMP R7, #0x2B   	; plus
	BEQ plus			; if equal branch to plus
	CMP R7, #0x2D   	; subtract
	BEQ subtract		; if equal branch to subtract
	CMP R7, #0x2A		; multiply
	BEQ multiply 		; if equal branch to multiply
	CMP R7, #0x2F	    ; Divide
	BEQ divide			; if equal branch to divide
	
plus 
	ADD R5, R4, R9  	; adds R4 and R9 and stores in R5
	B endRead			; branch to endRead
	
multiply
	MUL R5, R4, R9		; multiplies R4 and R9 and stores in R5
	B endRead			; branch to endRead
	
subtract
	SUB R5, R4, R9		; subracts R4 from R9 and stores in R5
	B endRead			; branch to endRead

divide
	CMP R4, R9				; compares R4 to R9
	BGT endDivide			; if greater than or equal to branch to endDivide
	ADD R10, R10, #1		; add 1 to quotient
	SUB R4, R4, R9			; subtract R4 from R9
	B 	divide				; branch to divide
	
endDivide
	MOV R5, R10				; give R5 the value of R10
	B endRead				; branch to endRead

endRead

stop	B	stop

	END	
