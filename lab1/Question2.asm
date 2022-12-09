.data
Greeting: .asciiz "a = "
Another: .asciiz "b = "
Result: .asciiz "c = "

.text
main:
	li $v0, 4 # print string
	la $a0, Greeting
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t0, $v0
	
	li $v0, 4 # print string
	la $a0, Another
	syscall

	li $v0, 5 # read integer
	syscall
	move $t1, $v0
	
	add $t1, $t1, $t0
	
	
	li $v0, 1
	move $a0, $t1
	syscall
	