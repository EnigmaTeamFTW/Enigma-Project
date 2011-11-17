TITLE ENIGMAP2V2.asm by Michael O'Brien
;TEAM F
INCLUDE irvine32.inc

.data

R3 BYTE "BDFHJLCPRTXVZNYEIWGAKMUSQO"
RevR3 BYTE "TAGBPCSDQEUFVNZHYIXJWLRKOM"
R2 BYTE "AJDKSIRUXBLHWTMCQGZNPYFVOE" 
RevR2 BYTE "AJPCZWRLFBDKOTYUQGENHXMIVS"
R1 BYTE "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
RevR1 BYTE "UWYGADFPVZBECKMTHXSLRINQOJ"
Reflector BYTE "YRUHQSLDPXNGOKMIEBFZCWVJAT"

charPrompt BYTE "Input a character>",0
initPrompt BYTE "Enter RIII initial condition>",0
invalid BYTE "Invalid Character -> V",0

;Enigma Transformations: R3->R2->R1->Reflector->RevR1->RevR2->RevR3
encryptOrder DWORD OFFSET R3,OFFSET R2,OFFSET R1,OFFSET Reflector,OFFSET RevR1,OFFSET RevR2,OFFSET RevR3

;Rotor Initialization Values 0=A,1=B,2=C,etc...
InitIII BYTE 0			
InitII BYTE 0
InitI BYTE 0
Ref byte 0

;Rotations contains addresses of variables for Rotor Values corresponding to the order in encryptOrder
Rotations DWORD OFFSET InitIII,OFFSET InitII,OFFSET InitI,OFFSET ref,OFFSET InitI,OFFSET InitII,OFFSET InitIII
.code
;
;--------------------------------------------------main PROC------------------------------------------------
main PROC

	call InitializeRotorIII

	inc InitIII				;Rotates RIII by only once one here for sake of Assignment Two
Start:
	call InputCharacter	

	mov esi,OFFSET encryptOrder
	mov ecx,LENGTHOF encryptOrder
	mov edi,OFFSET Rotations
	
L1:
    mov edx,[edi]
 	
	call Encrypt
	
	add esi,4
	add edi,4
	loop L1
	call CrLF
	JMP Start
	exit
main ENDP
;-------------------------------------------------------------main ENDP------------------------------------------------------

;----------------------------------------------------------InitializeRotorIII PROC-------------------------------------------
;    Procedure Tasks:	Prompt the user to initialize Rotor III 
;						Check that a Rotor has not been initialized to V
;						Echo Character on console
;						Calculate and place offset in InitIII
;	  Future Tasks:		Make flexible ->receive a offset of init value variable
;						call procedure to check that entered characer is A-Z, if a-z capitalized
InitializeRotorIII PROC

redo:
	mov edx,OFFSET initPrompt
	call WriteString
	call ReadChar

	CMP al,'V'			;Check whether V has been entered
	JNE notV
	mov edx,OFFSET invalid
	call Crlf
	call WriteString
	call Crlf
	JMP redo		;Re-enter character

notV:
	call WriteChar
	sub al,65				;calculate offset
	mov initIII,al			
	call Crlf

	ret
InitializeRotorIII ENDP
;--------------------------------------------------InitializeRotorIII ENDP------------------------------------------

;--------------------------------------------InputCharacter PROC-----------------------------------------------------
;	Procedure Tasks:	Prompts user to enter character for to be encrypted
;	Future Tasks:		call procedure to check A-Z,capitalize a-z
;						Call a Procedure to rotate rotors
;	Returns:			AL=Character
InputCharacter PROC

	mov edx,OFFSET charPrompt
	call WriteString
	call ReadChar
	call WriteChar
	;call Rotate		(for later use e.g. incremementing rotor values)
	call Crlf

	ret
InputCharacter ENDP
;--------------------------------------------InputCharacter ENDP-------------------------------------------------

;--------------------------------------------Encrypt PROC--------------------------------------------------------
;	Receives:			EDX=OFFSET of variable containing rotor offset 
;						ESI=OFFSET of an encryption string
;	Procedure Tasks:	
Encrypt PROC USES edi
	
	add al,[edx]
check1:					;check that al is <= 90, otherwise subtracts 26 until it fits in range
	CMP al,90
	JLE other
	sub al,26
	JMP check1
other:
	call WriteChar
	movzx ebx,al
	sub bl,65				;Calculates offset of character
	mov edi,[esi]
	mov al,BYTE PTR[edi+ebx]
	call WriteChar
	sub al,[edx]
Check2:				;checks that al is >=65 is its less, adds 26 until it fits in range
	CMP al,65
	JGE other2
	add al,26
	JMP Check2
other2:
	call WriteChar
	ret
Encrypt ENDP
;--------------------------------------------Encrypt ENDP--------------------------------------------------

END main
;--------------------------------------------END main-------------------------------------------------------