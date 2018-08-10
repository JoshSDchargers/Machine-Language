


.equ SWI_Open, 0x66 @open a file
.equ SWI_Close,0x68 @close a file
.equ SWI_PrChr,0x00 @ Write an ASCII char to Stdout
.equ SWI_PrStr, 0x69 @ Write a null-ending string 
.equ SWI_RdStr,0x6a @read string from a file
.equ SWI_PrInt,0x6b @ Write an Integer
.equ SWI_RdInt,0x6c @read an integer from a file
.equ SWI_PrStr,0x69 @print string from a file
.equ Stdout, 1   @Set output target to be Stdout
.equ SWI_Exit, 0x11 @Stop Execution
.text
start:


@@@ === OPENS AN INPUT FILE FOR READING === 

ldr r0,=InFileName @ set Name for input file
mov r1,#0 @ mode is input
swi SWI_Open @ open file for input
bcs InFileError @ Check Carry-Bit (C): if= 1 then ERROR




@@@ === SAVES THE FILE HANDLE IN MEMORY ===

ldr r1,=InFileHandle @ if OK, load input file handle
str r0,[r1] @ save the file handle

@@@ === READS SENTENCE UNTIL END OF FILE ===

ldr r0, =InFileHandle
ldr r0, [r0]
ldr r1, =MSG
mov r2, #1024
swi SWI_RdStr
bcs EmptyFileError
mov r9, r0 @ r9 stores the amount of characters of the input file.

RLoop:
cmp r9, r7
beq Output
ldrb r8, [r1] @ loads each character.


@@@ === 0x41 TO 0x5a ARE UPPERCASE IN HEXADECIMAL AND SWAP TO *===

Part1:
cmp r8, #0x5A
bgt Part2
cmp r8, #0x41
blt Part2
mov r8, #0x2a
strb r8, [r1]
add r1, r1, #1
add r7, r7, #1 @ increments r7 each time it does not equal r9.
bal RLoop


@@@ === 0x61 TO 0x7a ARE LOWERCASE IN HEXADECIMAL AND SWAP TO *===

Part2:
cmp r8, #0x7A
bgt Part3
cmp r8, #0x61
blt Part3
mov r8, #0x2a
strb r8,[r1]
add r1, r1, #1
add r7, r7, #1 @ increments r7 each time it does not equal r9.
bal RLoop

@@@ === 0x30 TO 0x39 ARE INTEGERS IN HEXADECIMAL AND SWAP TO #===

Part3:
cmp r8, #0x39
bgt Part4
cmp r8, #0x30
blt Part4
mov r8, #0x23
strb r8, [r1]
add r1, r1, #1
add r7, r7, #1 @ increments r7 each time it does not equal r9.
bal RLoop


@@@ === IF IT'S A SYMBOL DO NOTHING, BUT MOVE TO NEXT BYTE AND LOOP BACK TO BEGIN ===

Part4:
add r1, r1, #1 @ 
add r7, r7, #1 @ increments r7 each time it does not equal r9.
bal RLoop




@@@ === OUTPUT FILE === 
Output:
ldr r0, =OutFileName
mov r1, #1
swi SWI_Open
bcs OutFileError
ldr r1, =MSG
swi SWI_PrStr
swi SWI_Close
bal Exit




EmptyFileError: 
mov R0, #Stdout
ldr R1, =EmptyFileMsg
swi SWI_PrStr
bal Exit


InFileError:
mov r0, #Stdout
ldr r1, =FileOpenInpErrMsg
swi SWI_PrStr
bal Exit

OutFileError:
mov r0, #Stdout
ldr r1, =FileOpenOutErrMsg
swi SWI_PrStr
bal Exit


@@@ === CLOSING FILE ===
Close:
ldr r0, = InFileHandle
ldr r0, [r0]
swi SWI_Close






Exit:
swi SWI_Exit @ stops executing


.data
.align
InFileHandle:  .word 0
OutFileHandle:  .word 0 
MSG: .skip 1024
InFileName: .asciz "input.txt"
OutFileName: .asciz "output.txt"
EmptyFileMsg: .asciz "File is empty.\n"
FileOpenInpErrMsg: .asciz "Failed to open input file \n"
FileOpenOutErrMsg:  .asciz "Failed to open output file \n"
.end



