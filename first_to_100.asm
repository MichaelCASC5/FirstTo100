#
#	HUNTER COLLEGE - FALL 2023
#	MIPS GAME
#	
#	FIRST TO 100
#	BY VERTEX
#
.data
	#formatting
	clear:  .byte   0x1B,0x5B,0x33,0x3B,0x4A,0x1B,0x5B,0x48,0x1B,0x5B,0x32,0x4A
	backslash: .asciiz "\n"
	divider: .asciiz "================\n"

	#texts and instructions
	introduction: .asciiz "\nBe the first to add up the numbers to 100!\nYou can only add a value from 1 to 10 per turn.\n\n"
	instructInput: .asciiz "\nEnter an integer from 1 to 10:\n"
	currentSum: .asciiz "\nCurrent Sum: "
	computerSum: .asciiz "\nThe sum is now "
	computerSum1: .asciiz ", to which the computer adds: "
	tryagainmessage: .asciiz "\nOut of range! You must enter an integer in the range of 1 through 10.\n"
	here: .asciiz "Here"

	#endgame statements
	victory: .asciiz "\nCongratulations! You added to 100 first and beat the computer.\n"
	defeat: .asciiz "\nSorry. The computer added to 100 first and beat you.\n"

	#inputs
	int: .word # including '\0' #.space 10

.text

#Clears the screen
clearscreen:
	#clears screen using .byte hex commands
	la      $a0,clear
    li      $v0,4
    syscall

	#clear console through a series of backslashes

	#loop
	#vars
	addi $t0, $zero, 0
	addi $t1, $zero, 10

	clearconsoleloop:
	beq $t0, $t1, main
	#prints space
	la $a0, backslash
	li $v0, 4
	syscall

	#i++
	addi $t0,$t0,1
	j clearconsoleloop

main:
	#prints introduction
	la $a0, introduction
	li $v0, 4
	syscall
	
	#THE SUM THAT BOTH SIDES ARE ADDING TO AND COMPETING WITH
	addi $s0, $zero, 0

#PROMPT USER FOR INPUT This is the user's turn and will loop
turn:
	#prints divider for formatting
	la $a0, divider
	li $v0, 4
	syscall

	#print current sum text
	la $a0, currentSum
	li $v0, 4
	syscall 

	#print the actual value of sum
	li $v0, 1
	move $a0, $s0
	syscall

	#empty line underneath the print of the current sum
	la $a0, backslash
	li $v0, 4
	syscall

	#if the user inputs a value outside the given range, the program will prompt again
	askuserforinput:
		#print instruction to enter int input
		la $a0, instructInput
		li $v0, 4
		syscall

		#reads user int input
		li $v0, 5
		syscall

		#moves user input elsewhere (to t2)
		addi $t2, $v0, 0

		#if(t2 < 1 || t2 > 10)	if t2 out of range [0,10], then return 1 (true)
		addi $t0, $zero, 1
		addi $t1, $zero, 10
		slt $t0, $t2, $t0	#t0 = t2 < 1
		slt $t1, $t1, $t2	#t1 = 10 < t2
		or $t0, $t0, $t1	#t0 = t0 || t1
		
		#print to let the user know the input was out of range if it was
		beq $t0, $zero, skiptryagainmessage	#if t2 was in range, skip the "try again" message
		la $a0, tryagainmessage
		li $v0, 4
		syscall
		skiptryagainmessage:

		#if t2 (the user input) is out of range, loop back and try again
		bne $t0, $zero, askuserforinput

	#adds user input to the sum
	add $s0, $s0, $t2

	#CHECK IF THE USER WON THE GAME
	#if (sum >= 100): exit game loop
	addi $t0, $zero, 99
	blt $t0, $s0, userVictory



	#COMPUTER'S TURN



	#Print the current sum right before the computer adds to it
	#print lead up string
	la $a0, computerSum
	li $v0, 4
	syscall
	# print sum
	li $v0, 1
	move $a0, $s0
	syscall
	#print fall off string
	la $a0, computerSum1
	li $v0, 4
	syscall

	#call procedure
	#CALCULATE WHAT THE COMPUTER'S MOVE SHOULD BE
	add $a0,$zero,$s0	#function parameter (current sum)
	jal findComputer	#function
	add $t0, $zero, $v0	#function output

	# #print a register
	li $v0, 1
	move $a0, $t0
	syscall

	#print backslash
	la $a0, backslash
	li $v0, 4
	syscall

	#COMPUTER ADDS TO SUM
	add $s0, $s0, $t0

	#CHECK IF THE COMPUTER WON THE GAME
	#if (sum >= 100): exit game loop
	addi $t0, $zero, 99
	blt $t0, $s0, computerVictory

	j turn

findComputer:	#parameters: ($a0) returns: ($v0)
    addi $sp,$sp,-4     #Moving Stack pointer
    sw $t0, 0($sp)      #Store previous value

	#storing input else where
	add $t2, $zero, $a0
	#Procedure Body
	addi $t0, $zero, 111
	addi $t1, $t2, 11
	searchForOutput:
		addi $t0, $t0, -11
		bgt $t0, $t1, searchForOutput

	#OUTPUT STORED TO $t0
	sub $t0, $t0, $t2
	
	#making sure output is in range
	addi $t1, $zero, 0
	addi $t2, $zero, 11

	#if ($t0 > 0)
	bgt $t0, $t1, skipoutputlessthan1
	addi $t0, $zero, 1
	skipoutputlessthan1:
	
	#if ($t0 < 11)
	blt $t0, $t2, skipoutputgreaterthan10
	addi $t0, $zero, 10
	skipoutputgreaterthan10:

    add $v0,$zero,$t0      #FUNCTION OUTPUT

    lw $t0, 0($sp)      #Load previous value
    addi $sp,$sp,4      #Moving Stack pointer 
    jr $ra              #return (Copy $ra to PC)	

userVictory:
	#prints divider for formatting
	la $a0, divider
	li $v0, 4
	syscall

	la $a0, victory
	li $v0, 4
	syscall

computerVictory:
	#prints divider for formatting
	la $a0, divider
	li $v0, 4
	syscall

	la $a0, defeat
	li $v0, 4
	syscall
