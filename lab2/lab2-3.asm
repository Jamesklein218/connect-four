.data
arr: .space 40
space: .asciiz " "
swap: .asciiz "swap"
.text
main:
	# input
	addi $t0, $zero, 0
while1:
	beq $t0, 40, exit
	
	li $v0, 5 # read integer
	syscall
	sw $v0, arr($t0) 
	addi $t0, $t0, 4
	j while1
exit: 
	
	# Bubble sort
	addi $t0, $zero, 0 # i = 0
iloop:	
	beq $t0, 36, exit_i
	addi $t1, $zero, 0 # j  = 0
	jloop: 
		add $t1, $t1, $t0 # j = j + i
		beq $t1, 36, exit_j
		sub $t1, $t1, $t0 # j = j - 1
		
		lw $t2, arr($t1) # arr[j]
		addi $t1, $t1, 4
		lw $t3, arr($t1) # arr[j + 1]
		subi $t1, $t1, 4
 
		slt $t4, $t2, $t3 # if (arr[i + 1] < arr[i])
		if: 	bne $t4, 1, else 
		
			sw $t3, arr($t1) # arr[j]
			addi $t1, $t1, 4
			sw $t2, arr($t1) # arr[j + 1] 
			subi $t1, $t1, 4
		else:
		
		addi $t1, $t1, 4
		j jloop
	exit_j:

	addi $t0, $t0, 4
	j iloop
exit_i:
	
	addi $t0, $zero, 0 # i
printloop:
	beq $t0, 40, exit_print
	lw $t1, arr($t0)
	
	li $v0, 1
	move $a0, $t1
	syscall 
	
	li $v0, 4 # print string
	la $a0, space
	syscall
	
	addi $t0, $t0, 4
	j printloop
exit_print:

	
	