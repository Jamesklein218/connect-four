.data
	fin: .asciiz "/Users/khoa/MIPS/lab3/khoa.txt"
	buffer_write: .asciiz "The quick brown fox jumps over the lazy dog.\n"
	buffer_read: .space 871
	text_length: .word 1000

.text
	# Allocate memory
	li $v0, 9 		# system call code for dynamic allocation
	lw $a0, text_length	# $a0 contains number of bytes to allocate
	syscall
	
	move $s0, $v0
	
	# Open (for reading) a file
	li $v0, 13		# system call for open file
	la $a0, fin		# input file name
	li $a1, 0		# Open for reading (flags are 0: read, 1: write)
	li $a2, 0		# mode is ignored
	syscall			# open a file (file descriptor returned in $v0)
	move $s6, $v0		# save the file descriptor
	
	# Read from file
	li $v0, 14		# system call for read
	move $a0, $s6		# file descriptor
	la $a1, 0($s0)		# address of buffer read
	lw $a2, text_length	# hardcoded buffer length
	syscall			# read file
	
	# Print the String out
	li $v0, 4
	la $a0, 0($s0)
	syscall
	
  	# Close the file 
  	li   $v0, 16       	# system call for close file
  	move $a0, $s6      	# file descriptor to close
  	syscall            	# close file
  	
  	li $v0, 10		# exit
		


    


	
	
