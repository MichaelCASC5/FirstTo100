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
	
	#if (sum >= 100): exit game loop
	addi $t0, $zero, 99
	blt $t0, $s0, finishgame

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
	tryagain:
		#print instruction to enter int input
		la $a0, instructInput
		li $v0, 4
		syscall

		#reads user int input
		li $v0, 5
		syscall

		#moves user input elsewhere (to t2)
		addi $t2, $v0, 0

		#if(s0 < 1 || s0 > 10)
		addi $t0, $zero, 1
		addi $t1, $zero, 10
		slt $t0, $s0, $t0	#t0 = s0 < 1
		slt $t1, $t1, $s0	#t1 = 10 < s0
		# mult $t0, $t1	#t0 = t0 & t1

		#print a register
		li $v0, 1
		move $a0, $t0
		syscall

	#adds user input to the sum
	add $s0, $s0, $t2

	#empty line underneath user input
	la $a0, backslash
	li $v0, 4
	syscall

	#print a register
	# li $v0, 1
	# move $a0, $s0
	# syscall

	j turn

finishgame:





#REFERENCE SHEET

# 	jal addthem      # call procedure
#     add $t3,$0,$v0   # move the return value from $v0 to where we want
#     syscall

# addthem:
#     addi $sp,$sp,-4     # Moving Stack pointer
#     sw $t0, 0($sp)      # Store previous value

#     add $t0,$a0,$a1     # Procedure Body
#     add $v0,$0,$t0      # Result

#     lw $t0, 0($sp)      # Load previous value
#     addi $sp,$sp,4      # Moving Stack pointer 
#     jr $ra              # return (Copy $ra to PC)


#user input for str
	# la $a0, input # address to store string at
	# li $a1, 10 # maximum number of chars (including '\0')
	# li $v0, 8 #use 8 for str input
	# syscall