.data
	# CONSTANTS: Contain fixed, unchangable variable declaration
	CAPACITY: 	.word 42
	ROW_SIZE: 	.word 6
	COLUMN_SIZE:	.word 7
	
	# <Utility String>: String component for UI/UX 
	WELCOME: 		.asciiz "Welcome to FOUR IN A ROW!!\nAssignment of Tran Ngoc Dang Khoa\nRepository: github.com/Jamesklein218/four-in-a-row (Private)\n\n_________________________________________________\n| The rule is simple:                           |\n|                                               |\n| 1. Each player (X or O) will take turn        |\n|    dropping the coint down                    |\n| 2. Whoever gets 4 Xs or Os first will win     |\n| 3. Each player will have 3 times to undo      |\n|    your move. Fail to do so will result in a  |\n|    loss.                                      |\n| 4. Each player will have 3 times to violate   |\n|    the input. Fail to do so will result in a  |\n|    loss.                                      |\n-------------------------------------------------\n"
	ENDL: 			.asciiz	"\n"
	SPACE: 			.asciiz " "
	TAB: 			.asciiz "\t"
	
	ASK_NAME_PLAYER1:	.asciiz "Enter Player 1's name (below 20 letters):\t"
	ASK_NAME_PLAYER2: 	.asciiz "Enter Player 2's name (below 20 letters):\t"
	ASK_SYMBOL:		.asciiz "You will play first! Please choose your symbol (0 for 'X' or else for 'O'):\t"
	
	P1_symbol: 		.asciiz "X"
	P2_symbol:		.asciiz "O"
	BOARD_NUMBERING: 	.asciiz "\t\t   1     2     3     4     5     6     7\n"
	BOARD_HORIZONTAL:	.asciiz "\t\t___________________________________________\n"
	BOARD_EMPTY_1: 		.asciiz "\t\t|     |     |     |     |     |     |     |\n"
	BOARD_EMPTY_2: 		.asciiz "|  "
	BOARD_EMPTY_3:		.asciiz "|\n"
	BOARD_EMPTY_4: 		.asciiz "\t\t|_____|_____|_____|_____|_____|_____|_____|\n"
		
	
	# DATA STORAGE: Use to store allocated, memory 
	game_board: 	.word 0, 0, 0, 0, 0, 0, 0,  	# 42 slots * 4 bytes for integer = 168 bytes
			      0, 0, 0, 0, 0, 0, 0,	# Here we use the column major strategy, with the below formulae:
			      0, 0, 0, 0, 0, 0, 0,	# Address = baseAddress + (columnIndex * rowSize + rowIndex) * datasize
			      0, 0, 0, 0, 0, 0, 0,
			      0, 0, 1, 2, 0, 0, 0,
			      0, 0, 0, 0, 0, 0, 0
			      
	game_history: 	.space 168	# 42 slots storing maximum of 42 steps (1 for player 1 and 2 for player 2)
	
	rounds:		.word 3		# Number of rounds (from 1 to maximum capcity (42) )
	
	Player1: 	.space 20	# Name of the Player1
	Player2: 	.space 20	# Name of the Player2	
	P1_undo_count:	.word 3		# Player 1's undo count
	P2_undo_count:	.word 3		# PLayer 2's undo count
	
	P1_violation:	.word 3		# Player1's violation count
	P2_violation:	.word 3		# Player2's violation count
		
	# FLAGS: Checker flags for the game
	status: 	.word 0		# 0 for undone, 1 for Player1 won, 2 for Player2 won
	current_player:	.word 1		# 1 for Player 1 and 2 for Player 2
	
.text
	j main
	
	# UI FUNCTIONS
	
	# display_start (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Display the console text at the start of the game
	display_start:
		subi $sp, $sp, 4
		sw $ra, 0($sp)
	
		# WELCOME
		la $a0, WELCOME
		li $v0, 4			# Print String status code
		syscall 			# Print String
		
		la $a0, ENDL
		syscall				# Print String
		
		jal init_game			# Call to initialize the game by request necessary input from user
		
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	
	display_session:
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		
		jal print_board
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	display_end:
	
	# print_board (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Print out the game board using 2 while loop
	print_board:
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		
		li $v0, 4			# Print String
		
		la $a0, BOARD_NUMBERING
		syscall
		
		la $a0, BOARD_HORIZONTAL
		syscall
		
		# Traverse the game_board with i and j for every i in [0, 5] and j in [0, 6]
		lw $s2, ROW_SIZE		# row size
		lw $s3, COLUMN_SIZE		# column size
		
		addi $s0, $0, 0			# int i = 0
		I_loop:
			slt $s2, $s0, $s2		# while i < row size
			bne $s2, 1, exit_I_loop
			
			la $a0, BOARD_EMPTY_1
			syscall
			
			la $a0, TAB
			syscall
			syscall
			
			addi $s1, $0, 0				# int j = 0
			J_loop:
				slt $s3, $s1, $s3		# while j < column size
				bne $s3, 1, exit_J_loop
				
				la $a0, BOARD_EMPTY_2
				syscall
				
				add $a1, $zero, $s0
				add $a2, $zero, $s1
				jal get_address			# Get Address and stores in $a0
					
				lw $a0, 0($a0)
				beq $a0, 1, if_player1_move
				beq $a0, 2, if_player2_move
				la $a0, SPACE
				syscall
				j exit_branch
				if_player1_move:
					la $a0, P1_symbol
					syscall
					j exit_branch
				if_player2_move:
					la $a0, P2_symbol
					syscall
				exit_branch:
					
				la $a0, SPACE
				syscall
				syscall
					
				addi $s1, $s1, 1
				lw $s3, COLUMN_SIZE
				j J_loop
			exit_J_loop:
			
			la $a0, BOARD_EMPTY_3
			syscall
			
			la $a0, BOARD_EMPTY_4
			syscall
			
			lw $s3, COLUMN_SIZE
			addi $s0, $s0, 1
			lw $s2, ROW_SIZE
			j I_loop
		exit_I_loop:
		
		
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
	# clear*:
	
	# delay*:
	
	# GAME ENGINE
	
	# init_game (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Request necessary input from the user
	init_game:
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		
		jal get_random_player		# Randomly choose 1 or 2 to $v0
		
		la $a0, current_player
		sw $v0, 0($a0)			# Store to current_player
		move $t0, $v0
		
		la $a0, ASK_NAME_PLAYER1
		li $v0, 4
		syscall				# Print String
		
		beq $t0, 1, P1_start
		la $a0, Player2			# String buffer
		j exit_start_1
		P1_start:
			la $a0, Player1		# String buffer
		exit_start_1:
		li $a1, 20			# Maximum character to read
		li $v0, 8			# Read String status code
		syscall				# Read String to Player1
		
		la $a0, ENDL
		li $v0, 4			# Print String status code
		syscall
		
		la $a0, ASK_NAME_PLAYER2
		syscall 			# Print String			
		
		beq $t0, 1, P1_start_2
		la $a0, Player1			# String buffer
		j exit_start_2
		P1_start_2:
			la $a0, Player2		# String buffer
		exit_start_2:
		li $a1, 20			# Maximum character to read
		li $v0, 8			# Read String status code
		syscall 			# Read String to Player2
		
		la $a0, ENDL
		li $v0, 4
		syscall
		
		la $a0, Player1
		li $v0, 4
		syscall
		
		la $a0, ASK_SYMBOL
		syscall
		
		li $v0, 5			# Read integer
		syscall
		
	
		beq $v0, 0, p1_is_X
			# Swap character
			lb $t0, P1_symbol
			lb $t1, P2_symbol
			sb $t0, P2_symbol
			sb $t1, P1_symbol
		j p1_is_X
		p1_is_X:
		
		la $a0, ENDL
		li $v0, 4
		syscall
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	
	# Utility
	
	# get_random_player (int)
	# Parameter Register: 	None
	# Return Register: 	$v0
	# Function: 		Pseudo-randomly choose player 1 or 2 start first (is X, the other is Y). 
	#			Return 1 for Player 1 and 2 for Player 2
	get_random_player:
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		
		addi $a0, $0, 2			# i.d. return value
		addi $a1, $0, 2			# Range
		li $v0, 42        		# Get random number in range [int] 
    		syscall
    		
    		add $a0, $a0, 1			# increase range from [0, 1] to [1, 2
    		move $v0, $a0
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	# get_address (int)
	# Parameter Register: 	$a1, $a2
	# Return Register: 	$a0
	# Function: 		Return the address of the coordinate ($a1, $a2) on the board 
	#			base one the formula [Address = baseAddress + (rowIndex * columnSize + columnIndex) * datasize]
	get_address:
		subi $sp, $sp, 8
		sw $s0, 4($sp)
		sw $ra, 0($sp)
		
		lw $s0, COLUMN_SIZE		# Loading COLUMN_SIZE
		mul $a0, $a1, $s0		# Perform rowIndex * columnSize
		add $a0, $a0, $a2		# Perform rowIndex * columnSize + columnIndex
		sll $a0, $a0, 2			# Perform (rowIndex * columnSize + columnIndex) * 4
		la $s0, game_board		# Loading game_board address
		add $a0, $a0, $s0		# Perform Address = baseAddress + (rowIndex * columnSize + columnIndex) * datasize
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
	main:
		jal display_start		# Display the start screen
		
		session_loop:
			jal display_session
		exit_session_loop:
		
		# Close the program
		li $v0, 10
        	syscall
