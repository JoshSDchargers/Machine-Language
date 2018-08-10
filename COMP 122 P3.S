

	.equ Sec1, 1000 @ 1 seconds interval
	.equ Point1Sec, 100 @ 0.1 seconds interval
	.equ EmbestTimerMask, 0x7fff @ 15 bit mask for timer values
	.equ Top15bitRange, 0x0000ffff @(2^15) -1 = 32,767
	.equ SWI_SETSEG8, 0x200 @display on 8 Segment
	.equ SWI_SETLED, 0x201 @LEDs on/off
	.equ SWI_CheckBlack, 0x202 @check Black button
	.equ SWI_CheckBlue, 0x203 @check press Blue button
	.equ SWI_DRAW_STRING, 0x204 @display a string on LCD
	.equ SWI_DRAW_INT, 0x205 @display an int on LCD
	.equ SWI_CLEAR_DISPLAY,0x206 @clear LCD
	.equ SWI_DRAW_CHAR, 0x207 @display a char on LCD
	.equ SWI_CLEAR_LINE, 0x208 @clear a line on LCD
	.equ SWI_EXIT, 0x11 @terminate program
	.equ SWI_GetTicks, 0x6d @get current time 
	.equ SEG_A, 0x80 @ patterns for 8 segment display
	.equ SEG_B, 0x40 @byte values for each segment
	.equ SEG_C, 0x20 @of the 8 segment display
	.equ SEG_D, 0x08
	.equ SEG_E, 0x04
	.equ SEG_F, 0x02
	.equ SEG_G, 0x01
	.equ SEG_P, 0x10
	.equ LEFT_LED, 0x02 @bit patterns for LED lights
	.equ RIGHT_LED, 0x01
	.equ LEFT_BLACK_BUTTON,0x02 @bit patterns for black buttons
	.equ RIGHT_BLACK_BUTTON,0x01 @and for blue buttons
	.equ BLUE_KEY_00, 0x01 @button(0)
	.equ BLUE_KEY_01, 0x02 @button(1)
	.equ BLUE_KEY_02, 0x04 @button(2)
	.equ BLUE_KEY_03, 0x08 @button(3)
	.equ BLUE_KEY_04, 0x10 @button(4)
	.equ BLUE_KEY_05, 0x20 @button(5)
	.equ BLUE_KEY_06, 0x40 @button(6)
	.equ BLUE_KEY_07, 0x80 @button(7)
	.equ BLUE_KEY_08, 1<<8 @button(8) - different way to set
	.equ BLUE_KEY_09, 1<<9 @button(9)
	.equ BLUE_KEY_10, 1<<10 @button(10)
	.equ BLUE_KEY_11, 1<<11 @button(11)
	.equ BLUE_KEY_12, 1<<12 @button(12)
	.equ BLUE_KEY_13, 1<<13 @button(13)
	.equ BLUE_KEY_14, 1<<14 @button(14)
	.equ BLUE_KEY_15, 1<<15 @button(15)


_start:


@ Demonstration of Embest S3CE40 development board view
@ ===== Assume the EQU declaration from previous examples
@Clear the board, clear the LCD screen
	mov r11, #0
	swi SWI_CLEAR_DISPLAY
	mov r0, #0
	mov r1, #0
	mov r2, #0
@Both LEDs off
	mov r0,#0
	swi SWI_SETLED
@8-segment blank
	mov r0,#0
	swi SWI_SETSEG8



BLUELOOP:
@wait for user to press blue button
	mov r0,#0

	
BB1:

	swi SWI_CheckBlue @get button press into R0
	cmp r0,#0
	beq BB1 @ if zero, no button pressed


	cmp r0, #BLUE_KEY_15
	beq FIFTEEN
	cmp r0, #BLUE_KEY_14
	beq EQUALS
	cmp r0, #BLUE_KEY_13
	beq THIRTEEN
	cmp r0, #BLUE_KEY_12
	beq CLEAR
	cmp r0, #BLUE_KEY_11
	beq ELEVEN
	cmp r0, #BLUE_KEY_10
	beq TEN
	cmp r0,#BLUE_KEY_09
	beq NINE
	cmp r0,#BLUE_KEY_08
	beq EIGHT
	cmp r0,#BLUE_KEY_07
	beq SEVEN
	cmp r0,#BLUE_KEY_06
	beq SIX
	cmp r0,#BLUE_KEY_05
	beq FIVE
	cmp r0,#BLUE_KEY_04
	beq FOUR
	cmp r0,#BLUE_KEY_03
	beq THREE
	cmp r0,#BLUE_KEY_02
	beq TWO
	cmp r0,#BLUE_KEY_01
	beq ONE
	cmp r0,#BLUE_KEY_00
	beq ZERO
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#0
	BL Display8Segment
	bal CKBLUELOOP
ZERO:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#7
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP

	
ONE:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#8
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
TWO:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#9
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
THREE:@@ADD
	
	cmp r11, #1
	bne ERROR
	swi SWI_CLEAR_LINE
	mov r8, #1
	BL COUNTER
	bal CKBLUELOOP
FOUR:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#4
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
FIVE:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#5
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
SIX:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#6
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
SEVEN:@@SUB
	cmp r11, #1
	bne ERROR
	swi SWI_CLEAR_LINE
	mov r8, #2
	BL COUNTER
	bal CKBLUELOOP
EIGHT:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#1
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
NINE:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#2
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
TEN:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#3
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
ELEVEN:@@AND
	cmp r11, #1
	bne ERROR
	swi SWI_CLEAR_LINE
	mov r8, #4
	BL COUNTER
	bal CKBLUELOOP
CLEAR: @@ Clear
	swi SWI_CLEAR_DISPLAY
	mov r0,#0 @ clear 8-segment
	BL Display8Segment
	mov r1, #0
	mov r2, #0
	mov r0, #0
	mov r11, #0
	mov r4, #0
	
	bal CKBLUELOOP
THIRTEEN:
	swi 0x206
	cmp r11, #1 @@CHECKING IF AN ERROR
	beq ERROR
	cmp r11, #3
	beq ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1,#0
	mov r0,#0
	BL Display8Segment
	BL STORE
	BL COUNTER
	bal CKBLUELOOP
FOURTEEN:@@EQUALS
	cmp r11, #3
	bne ERROR
	mov r0,#5 @clear previous line 
	swi SWI_CLEAR_LINE
	mov r1, #0
	mov r0, #0x3D
	BL Display8Segment
	BL STORE
	mov r11, #0
	bal CKBLUELOOP
	
FIFTEEN:@@OR
	cmp r11, #1
	bne ERROR
	swi SWI_CLEAR_LINE
	mov r8, #3
	BL COUNTER
	bal CKBLUELOOP
STORE:
	stmfd sp!,{r0-r2,lr}
	cmp r11, #2
	beq StoreTwo
	mov r9,r0 @@@FIRST NUMBER
	bal Out
	StoreTwo:
	mov r10, r0 @@@@second number
	
	Out:

	ldmfd sp!,{r0-r2,pc}
	



EQUALS:
cmp r11, #3
bne ERROR

cmp r8, #1
beq addmyvalues
cmp r8, #2
beq submyvalues
cmp r8, #3
beq ormyvalues
cmp r8, #4
beq andmyvalues



@@perform the correct operation, store them into r4, and then 
@@its time to display to lcd screen
addmyvalues:
add r4, r9, r10 
BAL DISPLAYLCD

submyvalues:
sub r4, r9, r10
bal DISPLAYLCD


andmyvalues:
AND r4, r9, r10
bal DISPLAYLCD

ormyvalues:
ORR r4, r9, r10
BAL DISPLAYLCD

COUNTER:
@@keeping a tally how many times user pressed blue button
stmfd sp!,{r0-r2,lr}
add r11, r11, #1
ldmfd sp!,{r0-r2,pc}



DISPLAYLCD:
@@COMPARE R8 TO SEE WHAT THE THE USER ENTERED THEN BRANCH TO CORRECT 
@@LCD DISPLAY
cmp r8, #1
beq addingtolcd
cmp r8, #2
beq subbingtolcd
cmp r8, #3
beq orringtolcd
cmp r8, #4
beq andingtolcd

addingtolcd:@@DISPLAYING THE APPROPIATE INPUTTED VALUES AND OPERATION

mov r0,#1
mov r1,#1
mov r2,r9
swi 0x205
@@@@@@@@@@
mov r0,#4
mov r1,#1
ldr r2,=ADDMESSAGE
swi 0x204 @ display message
@@@@@@@@@@
mov r0,#7
mov r1,#1
mov r2,r10
swi 0x205
@@@@@@@@@@
mov r0,#10
mov r0,#10
mov r1,#1
ldr r2, =EQUALMESSAGE
swi 0x204
@@@@@@@@@@
mov r0,#13
mov r1,#1
mov r2,r4
swi 0x205
BAL CLEARFORNOW

subbingtolcd:@@DISPLAYING THE APPROPIATE INPUTTED VALUES AND OPERATION

mov r0,#1
mov r1,#1
mov r2,r9
swi 0x205
@@@@@@@@@@
mov r0,#4
mov r1,#1
ldr r2,=SUBMESSAGE
swi 0x204 @ display message
@@@@@@@@@@
mov r0,#7
mov r1,#1
mov r2,r10
swi 0x205
@@@@@@@@@@
mov r0,#10
mov r0,#10
mov r1,#1
ldr r2, =EQUALMESSAGE
swi 0x204
@@@@@@@@@@
mov r0,#13
mov r1,#1
mov r2,r4
swi 0x205
BAL CLEARFORNOW

orringtolcd:@@DISPLAYING THE APPROPIATE INPUTTED VALUES AND OPERATION
mov r0,#0
mov r1,#1
mov r2,r9
swi 0x205
@@@@@@@@@@
mov r0,#3
mov r1,#1
ldr r2,=ORMESSAGE
swi 0x204 @ display message
@@@@@@@@@@
mov r0,#7
mov r1,#1
mov r2,r10
swi 0x205
@@@@@@@@@@
mov r0,#10
mov r0,#10
mov r1,#1
ldr r2, =EQUALMESSAGE
swi 0x204
@@@@@@@@@@
mov r0,#13
mov r1,#1
mov r2,r4
swi 0x205
BAL CLEARFORNOW

andingtolcd:@@DISPLAYING THE APPROPIATE INPUTTED VALUES AND OPERATION
mov r0,#1
mov r1,#1
mov r2,r9
swi 0x205
@@@@@@@@@@
mov r0,#3
mov r1,#1
ldr r2,=ANDMESSAGE
swi 0x204 @ display message
@@@@@@@@@@
mov r0,#7
mov r1,#1
mov r2,r10
swi 0x205
@@@@@@@@@@
mov r0,#10
mov r0,#10
mov r1,#1
ldr r2, =EQUALMESSAGE
swi 0x204
@@@@@@@@@@
mov r0,#13
mov r1,#1
mov r2,r4
swi 0x205
BAL CLEARFORNOW

ERROR:@@PRINTS OUT E FOR ERROR
	swi SWI_CLEAR_LINE
	swi SWI_DRAW_STRING @ draw to the LCD screen
	mov r1,#0
	mov r0,#10 @ clear 8-segment
	mov r11, #0
	mov r9, #0
	mov r10, #0
	mov r4, #0
	mov r8, #0
	BL Display8Segment

CLEARFORNOW:
	mov r1, #0
	mov r2, #0
	mov r0, #0
	mov r11, #0
	mov r4, #0
	
	BAL BLUELOOP

CKBLUELOOP:
	bal BLUELOOP 
@Prepare to exit: lst message and clear the board
@draw a message to the lcd screen on line#10, column 1
	mov r0,#1 @ column number
	mov r1,#10 @ row number

	swi SWI_DRAW_STRING @ draw to the LCD screen
@Turn off both LED's
	ldr r0,=0
	swi SWI_SETLED
@8-segment blank
	mov r0,#0
	swi SWI_SETSEG8
	ldr r3,=2000 @delay a bit
	BL Wait
@Clear the LCD screen
	swi SWI_CLEAR_DISPLAY
	swi SWI_EXIT @all done, exit
@ ===== Display8Segment (Number:R0; Point:R1) 
@ Displays the number 0-9 in R0 on the 8-segment display
@ If R1 = 1, the point is also shown
Display8Segment:
	stmfd sp!,{r0-r2,lr}
	ldr r2,=Digits
	ldr r0,[r2,r0,lsl#2]
	tst r1,#0x01 @if r1=1,
	orrne r0,r0,#SEG_E @then show E
	swi SWI_SETSEG8
	ldmfd sp!,{r0-r2,pc}
@ ===== Wait(Delay:r3) wait for r3 milliseconds
@ Delays for the amount of time stored in r3 for a 15-bit timer
Wait:
	stmfd sp!,{r0-r5,lr}
	ldr r4,=0x00007FFF @mask for 15-bit timer
	SWI SWI_GetTicks @Get start time
	and r1,r0,r4 @adjusted time to 15-bit
Wloop:
	SWI SWI_GetTicks @Get current time
	and r2,r0,r4 @adjusted time to 15-bit
	cmp r2,r1
	blt Roll @rolled above 15 bits
	sub r5,r2,r1 @compute easy elapsed time
	bal CmpLoop
Roll: 
	sub r5,r4,r1 @compute rolled elapsed time
	add r5,r5,r2
CmpLoop:
	cmp r5,r3 @is elapsed time < delay?
	blt Wloop @Continue with delay
Xwait:ldmfd sp!,{r0-r5,pc}

Exit:
	swi SWI_EXIT
	

@@@==============END OF FILE================
	.data

	ADDMESSAGE:	.asciz "+"
	SUBMESSAGE:	.asciz "-"
	ANDMESSAGE:	.asciz "AND"
	ORMESSAGE:	.asciz "OR"
	EQUALMESSAGE:	.asciz "="
	NULLMESSAGE:	.asciz "								"
	Digits:
	.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_G @0
	.word SEG_B|SEG_C @1
	.word SEG_A|SEG_B|SEG_F|SEG_E|SEG_D @2
	.word SEG_A|SEG_B|SEG_F|SEG_C|SEG_D @3
	.word SEG_G|SEG_F|SEG_B|SEG_C @4
	.word SEG_A|SEG_G|SEG_F|SEG_C|SEG_D @5
	.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D|SEG_C @6
	.word SEG_A|SEG_B|SEG_C @7
	.word SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G @8
	.word SEG_A|SEG_B|SEG_F|SEG_G|SEG_C @9
	.word SEG_A|SEG_G|SEG_F|SEG_E|SEG_D @ E
	.word 0 @Blank display
	
	.end    
	
	
	

	
	