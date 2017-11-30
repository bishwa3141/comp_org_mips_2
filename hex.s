.data
	too_large:	.asciiz	"Too large"
	end_msg:    		.asciiz "All Characters printed"
	newline: 			.asciiz "\n"
	input: .space  1001
	err_msg:			.asciiz "NaN"
text
	main:
		
		li $v0, 8							#	Syscall code for user input
		la $a0, input 						#	Reading from the output
		li $a1, 1001
									# 	Maximum length for the string to be read from input
									
		move $s0, $a0						# 	Save the string to t0 register

		syscall 							#Making the read syscall

		la $a1, 0								#Initializing the starting index for the character of the substring

		j main_program

		

	main_program:
		
		move $t0, $a0						# 	Save the string to t0 register
		
		
		move $t1, $a1
		move $t2, $a1				
		
		lb $s1, ($s0)					

		li $v0, 1    # print_int
		move $a0, $t1
		syscall
		
		li $v0, 1    # print_int         
		move $a0, $t2
		syscall	
		
		li $v0, 4       # you can call it your way as well with addi 
		la $a0, newline       # load address of the string
		syscall
		
		
		beqz 	$s1, 		end_of_loop			#If "\0" found, end of loop

		beq  	$s1, 	10, 	end_of_loop			#For string less than 9, the last characters is "\n", so checking for that
		
		add 	$t0, $t0, 1						#Looking at the next character in the string
		addu 	$t2, $t2, 	1				#Incrementing the address
		
		bne 	$s1, 44,		main_program		# If the char is not ',' go back and look at the next character

		subu $t2, $t2, 1			#Since $t2 points to the comma, subtracting 1 from it gives the last index to the substring
		
		
		move $a0, $t2
		move $a1, $t1
		
		
		la $s2, 0 					# Keeing track of the length of the string being considered
		la $s3, 0					# Result
		la $s4, 0					# Boolean for checking if a space is found after a valid character
		la $s5, 0					# Boolean for valid character found

		jal subprogram_2						# Passing $a0 and $a1 as argument to the function.

		jal subprogram_3   					# Use the output from subprogram_2 to print the decimal value of the hex string
		
		
		addu $a0, $t1, 2								# Ignoring the ',' for both of the indices
		
		j main_program

	subprogram_2:
		beqz $a0, $a1  subprogram_3			# If the starting and ending index match, we have reached the end of the string. so
											# the result of the string. The variables are passed to the subprogram using stack
		
		move $t3, $a0
		addu $t0, $t0, $t3
		lb  $s5, ($t0)					# Starting with the first index of the substring
		

		beq 	$s5, 	32, 	space		# Case for when a space character is found
		
		move $a0, $s5

		jal subprogram_1		


		sll 	$s2,	$s2, 	4 			# Multiplying the result by 16 using bit-shift	
		addu 	$s2,	$s2, 	$v0 		# Adding the value of the character to the result

		addi $sp, $sp, -4  # Decrement stack pointer by 
		sw   $s2, 0($sp)   # Save $r3 to stack

		add 	$a0, $a0, 	1

		j 	subprogram_2


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


	subprogram_3:
		pop:  lw   $t0, 0($sp)   # Copy from stack to $r3
      	addi $sp, $sp, 4   # Increment stack pointer by 4

      	li $v0, 1					# Syscall code for printing out an integer
		move $a0, $t0				# Transfer $s2 to $a0 for printing
		syscall 					

		j main_program

	end_of_loop:
		li	$v0, 10					# system call code for exit = 10
		syscall

	invalid:
		la $t0, err_msg
		addi $sp, $sp, -4  # For three characters
		sw $t0, 0($sp)

		jre $rs

	valid_num:

		subu 	$v0, 	$a0, 	48				# Finding the real value of the character by subtracting
		jr $rs									#  Takes you back to the end of the instruction 'jal subprogram_2'

	valid_capital:

		subu 	$v0, 	$a0, 	55				# Finding the real value of the character by subtracting
		jr $rs 									#  Takes you back to the end of the instruction 'jal subprogram_2'


	valid_small:
		subu 	$v0, 	$a0, 	87				# Finding the real value of the character by subtracting
		jr $rs 									#  Takes you back to the end of the instruction 'jal subprogram_2'


	space:
		beqz	$s4, subprogram_2			# Checks if a character has already been found

		la 	$s3, 1							# Making note of a space found after a character is found

		j loop_through						# return back to the loop