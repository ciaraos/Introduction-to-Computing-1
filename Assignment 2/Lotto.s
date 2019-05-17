	AREA	Lotto, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR R1, =TICKETS	; Loads start address for TICKETS
	LDR	R2, =DRAW		; Loads start address for DRAW	
	LDR R3, =COUNT		; Loads starts address for COUNT
	LDR R3, [R3]		; Loads value of COUNT into R3
	LDR R4, =0			; numberCount(ticket) 			
	LDR R5, =0			; drawCount						
	LDR R6, =0			; matchCount					
	LDR R7, =0			; count	
	LDR R10, =0			; Store result in MATCH4
	LDR R11, =0			; Store result in MATCH5
	LDR R12, =0			; Store result in MATCH6
	
reload 
	LDR R2, =DRAW
	
compare 
	CMP R4, #6			; Compare numberCount to ticketSize
	BEQ loop			; Branch to loop if equal
	CMP R5, #6			; Compare drawCount to ticketSize
	BEQ while			; Branch to while if equal
	CMP R7, R3 			; Compare count to COUNT
	BEQ displayAns		; Branch to displayAns if equal
	
	LDRB R8, [R1]		; Load address of TICKETS
	LDRB R9, [R2]		; Load address of DRAW
	CMP R8, R9			; Compare TICKETS to DRAW
	BEQ match			; Branch to match if equal
	ADD R2, R2, #1		; Move to next address in DRAW
	ADD R5, R5, #1		; drawCount++
	B reload				;compare
	
match
	ADD R1, R1, #1		; Move to next address in TICKETS
	ADD R4, R4, #1		; numberCount++
	ADD R6, R6, #1		; matchCount++
	MOV R5, #0			; Reset drawCount
	B compare
	
while
	;LDR R2, =DRAW		; Reload start address of DRAW
	ADD R2, R2, #1		; Move to next address in TICKETS
	ADD R4, R4, #1		; numberCount++
	MOV R5, #0			; Reset drawCount
	B compare					;compare
	
loop
	CMP R6, #4			; Compare matchCount to 4
	BEQ match4			; If matchCount = 4 branch to match4
	CMP R6, #5			; Compare matchCount to 5
	BEQ match5			; If matchCount = 5 branch to match5
	CMP R6, #6			; Compare matchCount to 6
	BEQ match6			; If matchCount = 6 branch to match6
	MOV R4, #0			; Reset numberCount
	MOV R5, #0			; Reset drawCount
	MOV R6, #0			; Reset matchCount
	ADD R7, R7, #1		; count++
	ADD R1, R1, #1 		; Move to next address in TICKETS
	B reload
	
match4
	ADD R10, R10, #1	; 4matches++
	B reload
	
match5
	ADD R11, R11, #1	; 5matches++
	B reload
	
match6
	ADD R12, R12, #1	; 6matches++
	B reload
	
displayAns 
	LDR R1, =MATCH4		; Load address of MATCH4
	LDR R2, =MATCH5		; Load address of MATCH5
	LDR R3, =MATCH6		; Load address of MATCH6
	
	STRB R10, [R1]		; Store result in MATCH4
	STRB R11, [R2]		; Store result in MATCH5
	STRB R12, [R3]		; Store result in MATCH6
	B endWhl
	
endWhl
stop	B	stop 

	AREA	TestData, DATA, READWRITE
	
COUNT	DCD	3							; Number of Tickets
TICKETS	
		;DCB	3, 8, 11, 21, 22, 31		; Tickets
		;DCB	7, 23, 25, 28, 29, 32
		DCB	10, 11, 12, 22, 26, 30
	

DRAW	DCB	10, 11, 12, 22, 26, 30		; Lottery Draw

MATCH4	DCD	0
MATCH5	DCD	0
MATCH6	DCD	0

	END