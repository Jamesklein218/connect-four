.data
	arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	length: .word 40
.text
	j main
sum: 
	subi $sp, $sp, 12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	if: 	bne $s1, 0, else
		j return
	else:	
		lw $t1, 0($s0)
		add $a0, $a0, $t1
		addi $s0, $s0, 4
		addi $s1, $s1, -4
		
		jal sum
	return:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		addi $sp, $sp,12
		jr $ra

main: 
	la $s0, arr
	lw $s1, length
	li $a0, 0
	jal sum
	
	li $v0, 1 # print integer
	syscall
	
	
	