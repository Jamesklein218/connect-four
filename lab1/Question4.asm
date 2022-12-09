.data
arr: .space 20
newline : .asciiz "\n"

.text 
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0)
	addi $t0, $t0, 4
	
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0)
	addi $t0, $t0, 4
	
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0)
	addi $t0, $t0, 4
	
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0)
	addi $t0, $t0, 4
	
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0)
	
	li $v0, 1
	lw $t1, arr($t0)
	move $a0, $t1
	subi $t0, $t0, 4
	syscall 
	
	li $v0, 1
	lw $t1, arr($t0)
	move $a0, $t1
	subi $t0, $t0, 4
	syscall 
	
	li $v0, 1
	lw $t1, arr($t0)
	move $a0, $t1
	subi $t0, $t0, 4
	syscall 
	
	li $v0, 1
	lw $t1, arr($t0)
	move $a0, $t1
	subi $t0, $t0, 4
	syscall 
	
	li $v0, 1
	lw $t1, arr($t0)
	move $a0, $t1
	syscall 
	