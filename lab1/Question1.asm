.data
Greeting: .asciiz "Input your integer: "

.text
main:
	li $v0, 4 # print string
	la $a0, Greeting
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t0, $v0
	
	addi $t0, $t0, 1
	
	li $v0, 1 # print integer
	move $a0, $t0
	syscall