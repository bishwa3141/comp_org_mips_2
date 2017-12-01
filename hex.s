.data
	too_large:	.asciiz	"too large"
	end_msg:    		.asciiz "All Characters printed"
	newline: 			.asciiz "\n"
	input: .space  1001
	err_msg:			.asciiz "NaN"
.text
	main:
		
		li $v0, 8						#	Syscall code for user input
		la $a0, input 						#	Reading from the output
		li $a1, 1001
		syscall 						# 	Maximum length for the string to be read from input
		
		move $s0, $a0						# 	Save the string to t0 register
		move $t4, $s0
									#Making the read syscall

		la $s1, 0								#Initializing the starting index for the character of the substring
		la $s2, 0								#Initializing the starting index for the character of the substring
		la $s5, 0						# Boolean for checking if a space is found after a valid character
		la $s6, 0						# Boolean for non space character found
		j main_program
	

	main_program:
		
		lb $t3, ($t4)
							
		
		
		beqz   	$t3, 		end_of_loop			#If "\0" found, end of loop
		beq  	$t3, 	10, 	end_of_loop			#For string less than 9, the last characters is "\n", so checking for that
		
		
		la 	$s6, 1					# Making note that a non zecharacter has been found.
		
		addu 	$s2, 	$s2, 	1				#Incrementing the address
		addu	$t4, 	$t4,	1
		
		
		bne 	$t3, 44,		main_program		# If the char is not ',' go back and look at the next character

		subu 	$s2, $s2, 1			#Since $t2 points to the comma, subtracting 1 from it gives the last index to the substring
		
		beq 	$s1,	$s2 	empty		# If no character between commas, go to this branch
		
		move	$a0, $s0
		move 	$a1, $s1
		move 	$a2, $s2
		
		
		la $s3, 0 					# Keeing track of the length of the string being considered
		la $s4, 0					# Result
		
		


		jal subprogram_2						# Passing $a0 and $a1 as argument to the function.

		jal subprogram_3   					# Use the output from subprogram_2 to print the decimal value of the hex string
		
		addu $s2, $s2, 1								# Ignoring the ',' for both of the indices
		move $s1, $s2
		
		
		j main_program
	
	empty:
		la $a0, err_msg
		li $v0, 4    				#Printing Nan
		syscall
		
		addu $s2, $s2, 1
		move $s1, $s2
		
		
		j main_program
		
		
	subprogram_2:
		
		addu	$s3, $s3,  	1			#Incrementing the length of the hex number
		
		
		move $s7, $ra				#Saving the previous register
		move $s0, $a0
		
		move 	$t0, $a0
		move 	$t1, $a1  
		move 	$t2, $a2
		
		
		add $t0, $t0, $t1
		
		lb  $t3, ($t0)				# Starting with the first index of the substring
		
		
		move $a0, $t3
		
		jal 	subprogram_1
		
		sll 	$s4,	$s4, 	4 			# Multiplying the result by 16 using bit-shift	
		addu 	$s4,	$s4, 	$v0 		# Adding the value of the character to the result


		
		add 	$t1, $t1, 	1
		
		
		move 	$a1, $t1
		move 	$a2, $t2

		move $ra, $s7
		
		move $a0, $s0
		
		
		bgt $s3, 8, too_big			# Print too great for output greater than 8
		
		beq $t1, $t2, go_back  			# If the starting and ending index match, we have reached the end of the string. so
								# move towards printing					
		j subprogram_2
		

		
		
	subprogram_1:
		blt $a0, 48, invalid 		# checks if the number is less than 48. Goes to invalid if true

		ble $a0, 57, valid_num		# Checks if the ASCII of character is less than 58. At this point,
									# already greater than 48, so it is a valid num in the range 0-9

		blt $a0, 65, invalid 		# Checks if the ASCII of character is less than 68. At this point,
									# already greater than 58, so if true it is an invalid character

		ble $a0, 70, valid_capital	# Checks if the ASCII of character is less than 68. At this point,
									# already greater than 61, so if true it is a valid char in the range A - F

		blt $a0, 96, invalid 		# Checks if the ASCII of character is less than 96. At this point,
									# already greater than 70, so if true it is an invalid character

		ble $a0, 102, valid_small	# Checks if the ASCII of character is less than 58. At this point,
									# already greater than 96, so if true, it is a valid num in the range a-f

		j invalid 					#At this point, already greater than 103, so it is invalid
	
	go_back:
		addi $sp, $sp, -8  # Decrement stack pointer by 4
       		sw   $s4, 0($sp)   # Save the result to stack
       		
       		la $s4, 1
       		sw   $s4, 4($sp)   # Save the result to stack
       		
		jr $ra
		
	too_big:
		la $t0, too_large
		addi $sp, $sp, -8  		#For the error message
		sw $t0, 0($sp)
		
		li	$t0, 2			# Addding the error code to the stack
		sw $t0, 4($sp)
		
		jr $ra
		
	invalid:
		la $t0, err_msg
		addi $sp, $sp, -8  		#For the error message
		sw $t0, 0($sp)
		
		li	$t0, 3			# Addding the error code to the stack
		sw $t0, 4($sp)
		
		jr $s7

	valid_num:

		subu 	$v0, 	$a0, 	48				# Finding the real value of the character by subtracting
		jr $ra									#  Takes you back to the end of the instruction 'jal subprogram_2'

	valid_capital:

		subu 	$v0, 	$a0, 	55				# Finding the real value of the character by subtracting
		jr $ra 									#  Takes you back to the end of the instruction 'jal subprogram_2'


	valid_small:
		subu 	$v0, 	$a0, 	87				# Finding the real value of the character by subtracting
		jr $ra
		
		
	subprogram_3:
		lw   $a0, 0($sp)   # Copy from stack to $r3
	      	
	      	lw $a1, 4($sp)
   		addi $sp, $sp, 8   # Increment stack pointer by 4
		
		beq	$a1,	2	print_too_large
		beq	$a1,	3	print_nan
		la   $t2, 1000
		divu $a0, $t2			# Finding the quotient and the remainder

		mfhi $t0			# Storing the remainder in $s1
		mflo $t1					# Storing the quotient in $s2

		beq $t1, $zero, rem_print	# To avoid printing 0 if either the remainder or quotient is zero, the two cases
									# are handled separately

		beq $t0, $zero, quot_print	#

		j complete_print			# If neither are zero, both are printed
		
		jr $ra

	print_too_large:
		li $v0, 4
		syscall
		jr $ra
		
		
	quot_print:
		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $t1				# Transfer $s2 to $a0 for printing
		syscall 					

		jr $ra

	rem_print:
		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $t0				# Transfer $s1 to $a0 for printing
		syscall

		jr $ra

	complete_print:

		
		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $t1				# Transfer $s1 to $a0 for printing
		syscall

		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $t0				# Transfer $s2 to $a0 for printing
		syscall

		jr $ra
	
	print_nan:
		li $v0, 4
		syscall
		jr $ra
		

	end_of_loop:
	
		beq 	$s1,	$s2 	nan_terminate
		
		
		la $s3, 0 					# Keeing track of the length of the string being considered
		la $s4, 0					# Result
		la $s5, 0					# Boolean for checking if a space is found after a valid character
		la $s6, 0					# Boolean for valid character found
		
		
		move	$a0, $s0
		move 	$a1, $s1
		move 	$a2, $s2
		
		jal subprogram_2						# Passing $a0 and $a1 as argument to the function.

		jal subprogram_3   					# Use the output from subprogram_2 to print the decimal value of the hex string
		
		li	$v0, 10					# system call code for exit = 10
		syscall
		
	 									#  Takes you back to the end of the instruction 'jal subprogram_2'
	 nan_terminate:
	 	la $a0, err_msg
		li $v0, 4    				#Printing Nan
		syscall
		
	
		
		li	$v0, 10					# system call code for exit = 10
		syscall
		
																
	 

