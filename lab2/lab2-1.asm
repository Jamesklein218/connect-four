.data
	string: .asciiz "Ho Chi Minh City - University of Technology"
	size: .word 43
.text
main:
	lw $t0, size
	sub $t0, $t0, 1
	la $s0, string
while: 
	beq $t0, -1, exit
	li $v0, 11
	add $t2, $s0, $t0
	lb $a0, 0($t2)
	
	syscall
	
	sub $t0, $t0, 1
	j while
exit:
