TITLE Engima Data Structure

;Chapter 10 Page 367
;The route I've been taking so far with the enigma project has been a bit pointer happy,
;using pointers to arrays of pointers and so on which works fine but seems a bit messy. 
;Here's a possibility exploring the use of data structures to organize all information needed
;by a rotor. This might help with making procedures more flexible. 

INCLUDE irvine32.inc
INCLUDE macros.inc

ROTOR STRUCT 
	trans BYTE 26 DUP (?)
	revTrans BYTE 26 DUP (?)
	initializePrompt BYTE 40 DUP (0)   ;For use in prompting user to initialize a rotor
	rotorInit BYTE 0
	rotorPawl BYTE 0		;

ROTOR ENDS
.data

RotorIII ROTOR <"BDFHJLCPRTXVZNYEIWGAKMUSQO","TAGBPCSDQEUFVNZHYIXJWLRKOM","Enter RIII Rotor Initial condition>",0,22>
RotorII ROTOR <"AJDKSIRUXBLHWTMCQGZNPYFVOE","AJPCZWRLFBDKOTYUQGENHXMIVS","Enter RII initial condition>",0,5>
RotorI ROTOR <"EKMFLGDQVZNTOWYHXUSPAIBRCJ","UWYGADFPVZBECKMTHXSLRINQOJ","Enter RI initial condition>",0,17>
.code
main PROC


;Probably will involve a bit of code rewriting but this looks like it'd be the best way 
;to organize data and allow procedures to have easy access to all relevant information without 
;having to pass several offsets


	exit
main ENDP

END main