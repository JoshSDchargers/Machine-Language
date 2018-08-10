


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
@==================================================


RLoop:
cmp r9, r7
beq Exit
ldrb r8, [r1] @ loads each character.

check:
cmp r8 , #0x61
bge checker
bal array

checker:
cmp r8, #0x7A
blt lowercase
bal array

lowercase:
cmp r8, #0x6E
blt adder
cmp r8, #0x6F
bge suber

@===========================================================
checkupper:
cmp r8 , #0x31
bge checkerupper
bal array

checkerupper:
cmp r8, #0x5A
blt uppercased
bal array

uppercase:
cmp r8, #0x4E
beq adder
cmp r8, #0x4F
beq suber


adder:
add r8, r8, #13
sub r9, r9 , #1
bal Output

suber:
sub r8, r8, #13
sub r9, r9, #1
bal Output


array:
add r1, r1, #1
bal RLoop




@@@ === OUTPUT FILE === 
Output:
mov r0 ,r8
swi 0x00
bal array


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

MSG: .skip 512
InFileName: .asciz "mytext.dat"
OutFileName: .asciz "output.txt"
EmptyFileMsg: .asciz "File is empty.\n"
FileOpenInpErrMsg: .asciz "Failed to open input file \n"
FileOpenOutErrMsg:  .asciz "Failed to open output file \n"
.end



