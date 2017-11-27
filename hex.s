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


		j main_program:

		jal subprogram_2:						# Passing $a0 as argument to the function.

		jal subprogram_3:

	main_program
		lb $a0, ($t0)								#Initializing the starting address for the character of the string
		
		lb $a1, ($t0)								#Initializing the ending address for the character of the string.


		add $t1, $t1, 1								#Incrementing the address

		beq $a0, 44,   

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

