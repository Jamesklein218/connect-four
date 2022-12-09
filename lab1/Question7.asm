.data
arr: .space 40

.text
main:
	addi $t0, $zero, 0
while1:
	beq $t0, 40, exit
	
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0)
	addi $t0, $t0, 4
	j while1
exit: 
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