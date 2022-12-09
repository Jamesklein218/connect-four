.data
arr: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
newline: .asciiz "\n"
odd: .asciiz "\nOdd index sum: "
even: .asciiz "\nEven index sum: "

.text
main:
	addi $t0, $zero, 0
while1:
	beq $t0, 40, exit1
	
	lw $t1, arr($t0)
	addi $t0, $t0, 8
	add $t2, $t2, $t1
	j while1
exit1: 

	li $v0, 4 # print string
	la $a0, odd
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall 

	addi $t0, $zero, 4
	addi $t2, $zero, 0
while2:
	beq $t0, 44, exit2
	
	lw $t1, arr($t0)
	addi $t0, $t0, 8
	add $t2, $t2, $t1
	j while2
exit2: 
	li $v0, 4 # print string
	la $a0, even
	syscall
	
	li $v0, 1
	move $a0, $t2
	syscall 
	