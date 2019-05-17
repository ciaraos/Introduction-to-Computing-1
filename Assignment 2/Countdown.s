	AREA	Countdown, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR	R1, =cdWord				; Load start address of word
	LDR	R2, =cdLetters			; Load start address of letters
	LDR R7, =0					; Count for cdWord
	LDR R8, =0					; $count
while
	LDRB R4, [R1]				; Load address of cdWord into R4
	CMP R4, #0					; Compares cdWord to 0 (null terminiated)	
	BEQ while2 					; If equal branch to while 2
	ADD R1, R1, #1				; Move to next letter in cdWord
	ADD R7, R7, #1				; Count++
	B while						
	
while2 
	LDR R1, =cdWord				; Reload values for cdWord
	B compare 
	
compare
	LDRB R4, [R1]				; Loads address of cdWord into R4
	CMP R4, #0					; Compares cdWord to 0 (null terminated)
	BEQ endWhl		 			; Branch to endWhl if equal
	LDRB R5, [R2]				; Load address of letter into R5
	CMP R4, R5					; Compare cdWord and cdLetters (while (cdWord != cdLetters))
	BEQ match					; If cdWord can be made from cdLetters branch to match
	ADD R2, R2, #1				; Move to next letter in cdLetters
	CMP R5, #0					; Compare cdLetters to 0 (null terminated)
	BEQ endWhl					; Branch to notFormed if equal to 0
	B compare

match
	ADD R1, R1, #1				; cdWord = cdWord + 1
	LDR R6, ="$"				; Load $ to delete matching character
	ADD R8, R8, #1				; $count++
	STRB R6, [R2]				; Delete character when match found
	LDR R2, =cdLetters			; Reload cdLetters to go back to start of String
	B compare

canBeFormed
	MOV R0, #1					; Store 1 in R0 if cdWord can be formed from cdLetters
	B endWhl
notFormed
	MOV R0, #0					; Store 0 in R2 if cdWord can't be formed from cdLetters
	B endWhl
endWhl
	CMP R7, R8
	BEQ canBeFormed
	BNE notFormed
stop	B	stop

	AREA	TestData, DATA, READWRITE
	
cdWord
	DCB	"beets",0

cdLetters
	DCB	"daetebzsb",0
	
	END	
		
		
		
