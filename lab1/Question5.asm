.data
arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

.text
main:
	addi $t0, $zero, 0
while2:
	beq $t0, 40, exit2
	
	lw $t1, arr($t0)
	addi $t0, $t0, 4
	add $t2, $t2, $t1
	j while2
exit2: 
	li $v0, 1
	move $a0, $t2
	syscall
	 