.data
	too_large:	.asciiz	"too large" #Only using for debugging
	end_msg:    		.asciiz "All Characters printed"
	newline: 			.asciiz "\n"
	input: .space  1001
	err_msg:			.asciiz "NaN"
.text
	main:
		# Code to read input

		# Code to read user input
		li $v0, 8							#	Syscall code for user input
		la $a0, input 						#	Reading from the output
		li $a1, 1001							# 	Maximum length for the string to be read from input
		move $t0, $a0						# 	Save the string to t0 register

		

		syscall 							#Making the read syscall

		lb $a0, 0								#Initializing the starting index for the character of the substring
		
		lb $a1, 0								#Initializing the ending index for the character of the substring.


		j main_program:

		

	main_program
		
		lb $s0, ($t0)								
		
		addu 	$a1, $a1, 	1							#Incrementing the end index until ',' is found
		add 	$t0, $t0, 	1							#Incrementing the address

		beqz 	$s0, 			end_of_loop			#If "\0" found, end of loop

		beq  	$s0, 	10, 	end_of_loop			#For string less than 9, the last characters
																			# is "\n", so checking for that

		bneq 	$s0, 44,		main_program		# If the char is not ',' go back and look at the next character


		# When a ',' is found, call subprogram_2 to find the decimal value of the string, pass the start and end index of the string

		jal subprogram_2:						# Passing $a0 and $a1 as argument to the function.

		jal subprogram_3:   					# Use the output from subprogram_2 to print the decimal value of the hex string

		move $a0, $a1							# Set the new starting index to the end of the old starting index
		
		addu $a0, 2								# Ignoring the ',' for both of the indices
		addu $a1, 2

	subprogram_2:

		la $s4, 0 					#Length of the string being considered

		bgt $s4, 8, too_long

		la $s1, 0					# Result
		la $s3, 0					# Boolean for checking if a space is found after a valid character
		la $s4, 0					# Boolean for valid character found



		addu $s4, $s4, 1			#incrementing the counter for the length of string

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

