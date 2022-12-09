.data
	pi: .float 3.1415926535
	ans: .float 0.0
	msg: .asciiz "Input 0 for circle, 1 for triangle and else square: "
	
	circle_para: .asciiz "Radius =  "
	area: .asciiz "Area =  "
	triangle_para_h: .asciiz "h = "
	h: .float 0.0
	triangle_para_a: .asciiz "a = "
	a: .float 0.0
	half: .float 0.5
	
	
	rect_para: .asciiz "a =  "
	rect_para2: .asciiz "b =  "	
.text
main:
	# print integer
	li $v0, 4
	la $a0, msg
	syscall
	li, $v0, 5		# read integer
	syscall
	
	move $t0, $v0
	beq $t0, 0, circle
	beq $t0, 1, triangle
	j else
circle:
	
	li $v0, 4		# print string
	la, $a0, circle_para
	syscall
	li, $v0, 6		# read_float
	syscall
	s.s $f0, ans
	la $a0, ans
	l.s $f1, 0($a0)
	
	la $a1, pi
	l.d $f2, 0($a1)
	
	mul.s $f1, $f1, $f1
	mul.s $f1, $f1, $f2
	s.s $f1, ans 
	
	li $v0, 2		
	l.s $f12, ans
	syscall
	j EXIT
triangle:
	li $v0, 4		# print string
	la, $a0, triangle_para_h
	syscall
	li, $v0, 6		# read_float
	syscall
	s.s $f0, h
	
	li $v0, 4		# print string
	la, $a0, triangle_para_a
	syscall
	li, $v0, 6		# read_float
	syscall
	s.s $f0, a
	
	la $a0, h
	l.s $f1, 0($a0)
	la $a1, a
	l.s $f2, 0($a1)
	la $a2, half
	l.s $f3, 0($a2)
			
	mul.s $f1, $f1, $f2
	mul.s $f1, $f1, $f3
	s.s $f1, ans
	li $v0, 2
	l.s $f12, ans
	syscall
	j EXIT
else:
	li $v0, 4		# print string
	la, $a0, rect_para
	syscall
	li, $v0, 6		# read_float
	syscall
	s.s $f0, a
	
	li $v0, 4		# print string
	la, $a0, rect_para2
	syscall
	li, $v0, 6		# read_float
	syscall
	s.s $f0, h
	
	# TODO
	la $s0, a
	l.s $f1, 0($s0)
	la $s0, h
	l.s $f2, 0($s0)
	
	mul.s $f1, $f1, $f2
	
	s.s $f1, ans
	
	li $v0, 2
	l.s $f12, ans
	syscall
	j EXIT
EXIT:
	li $v0, 10		# exit
   	syscall