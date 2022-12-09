.data #u,v,a,b,c
	inputA: .asciiz "a:" 
	inputB: .asciiz "b:"
	inputC: .asciiz "c:"
	inputU: .asciiz "u:"
	inputV: .asciiz "v:"
	newline: .asciiz "\n"
	init: .float 0
	jump: .float 0.01
.text
j main
main:
	li $v0, 4		# print string
	la $a0, inputA
	syscall
	li $v0, 6		# read float
    	syscall
    	mov.s $f1, $f0

	li $v0, 4		# print string
	la $a0, inputB
	syscall
	
	li $v0, 6		# read float
    	syscall
    	mov.s $f2, $f0
	
	li $v0, 4		# print string
	la $a0, inputC
	syscall
	
	li $v0, 6		# read float
    	syscall
    	mov.s $f3, $f0

	li $v0, 4		# read float
	la $a0, inputU
	syscall
	
	li $v0, 6		# read float
    	syscall
    	mov.s $f4, $f0
	
	li $v0, 4		# read float
	la $a0, inputV
	syscall
	
	li $v0, 6		# read float
    	syscall
    	mov.s $f5, $f0
	
	
	lwc1 $f12, init		
	lwc1 $f8, jump		# delta x	
loop:	
	c.lt.s $f5, $f4
	bc1t exit
	mul.s $f6, $f4, $f4 	# u2
	mul.s $f6, $f1, $f6	# a * u2
	mov.s $f7, $f4 		# u
	mul.s $f7, $f7 ,$f2 	# b * u
	add.s $f12, $f12, $f6	# ans += a * u2
	add.s $f12, $f12, $f7 	# ans += b * u
	add.s $f12, $f12, $f3	# ans += c
	add.s $f4, $f4, $f8	# u += jump
	j loop
exit:
	mul.s $f12, $f12, $f8
	li $v0, 2
	syscall	
	
	li $v0, 10
	syscall