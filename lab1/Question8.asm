.data
arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
input: .asciiz "Input an integer number that is greater than 0 and less than 10: "

.text
main:
	li $v0, 4 # print string
	la $a0, input
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t0, $v0
	
	add $t0, $t0, $t0
	add $t0, $t0, $t0

	li $v0, 1 # read number
	lw $t1, arr($t0)
	move $a0, $t1
	syscall
	