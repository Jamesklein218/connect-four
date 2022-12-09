.data
aS: .asciiz "a = "
bS: .asciiz "b = "
cS: .asciiz "c = "
dS: .asciiz "d = "
q1S: .asciiz "\nf = "
q2S: .asciiz "\ng = "

.text
main:
	li $v0, 4 # a
	la $a0, aS
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t0, $v0
	
	li $v0, 4 # b
	la $a0, bS
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t1, $v0
	
	li $v0, 4 # c
	la $a0, cS
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t2, $v0
	
	li $v0, 4 # d
	la $a0, dS
	syscall
	
	li $v0, 5 # read integer
	syscall
	move $t3, $v0
	
	# (a + b) - (c - d - 2)
	add $t1, $t0, $t1 # (a + b)
	sub $t4, $t2, $t3 # (c - d)
	subi $t4, $t4, 2 # (c - d - 2)
	sub $t4, $t1, $t4	
	
	#  (a + b) * 3 − (c + d) * 2
	add $t5, $t2, $t3
	sub $t5, $t1, $t5
	add $t5, $t5, $t5
	add $t5, $t5, $t1
	
	li $v0, 4
	la $a0, q1S
	syscall	

	li $v0, 1
	move $a0, $t4
	syscall 
	
	li $v0, 4
	la $a0, q2S
	syscall
	
	li $v0, 1
	move $a0, $t5
	syscall 
	