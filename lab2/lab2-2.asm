.data
inputText: .asciiz "Input a positive integer: "
errorText: .asciiz "NOT A POSITIVE INTERGER!\n"
output: .asciiz  "Output: "
space: .asciiz " "

.text
inputloop:	
	li $v0, 4 # print string
	la $a0, inputText
	syscall
		
	li $v0, 5 # read integer
	syscall
	move $t0, $v0
	slti $t1, $t0, 1
	beq $t1, 0, exit_input
	j inputloop
exit_input:
	li $t1, 0
	li $t2, 1
	li $t3, 1
	
	li $v0, 1 # print integer 1
	addi $a0, $zero, 1
	syscall		
	li $v0, 4 # print string
	la $a0, space
	syscall
		
	sub $t0, $t0, 1
while:		
	beq $t0, 0, exit 
	
	add $t3, $t1, $t2 
		
	li $v0, 1 # print integer
	move $a0, $t3
	syscall
		
	li $v0, 4 # print string
	la $a0, space
	syscall
		
	move $t1, $t2
	move $t2, $t3
		
	sub $t0, $t0, 1
	j while
exit: 		
