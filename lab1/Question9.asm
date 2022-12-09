.data
arr: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19
space: .asciiz " "

.text
main:
	addi $t0, $zero, 0
while:
	beq $t0, 20, exit
	
	# set t1 = size - t0 - 1
	sub $t1, $zero, $t0
	add $t1, $t1, 40
	subi $t1, $t1, 4
	
	# swap
	lw $t2, arr($t0)
	lw $t3, arr($t1)
	sw $t3, arr($t0)
	sw $t2, arr($t1)
	
	addi $t0, $t0, 4
	j while
exit:

	addi $t0, $zero, 0
while2:
	beq $t0, 40, exit2
	
	lw $t1, arr($t0)
	
	li $v0, 1
	move $a0, $t1
	syscall 
	
	li $v0, 4 # print string
	la $a0, space
	syscall
	
	addi $t0, $t0, 4
	j while2
exit2:
