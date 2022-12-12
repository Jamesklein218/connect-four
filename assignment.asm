.data
	# CONSTANTS: Contain fixed, unchangable variable declaration
	CAPACITY: 	.word 42
	ROW_SIZE: 	.word 6
	COLUMN_SIZE:	.word 7
	
	# <Utility String>: String component for UI/UX 
	WELCOME: 		.asciiz "\t\t\tWelcome to FOUR IN A ROW!!\n\t\tAssignment of Tran Ngoc Dang Khoa\n\tRepository: github.com/Jamesklein218/four-in-a-row (Private)\n\n\t\t_________________________________________________\n\t\t| The rule is simple:                           |\n\t\t|                                               |\n\t\t| 1. Each player (X or O) will take turn        |\n\t\t|    dropping the coint down                    |\n\t\t| 2. Whoever gets 4 Xs or Os first will win     |\n\t\t| 3. Each player will have 3 times to undo      |\n\t\t|    your move. Fail to do so will result in a  |\n\t\t|    loss.                                      |\n\t\t| 4. Each player will have 3 times to violate   |\n\t\t|    the input. Fail to do so will result in a  |\n\t\t|    loss.                                      |\n\t\t-------------------------------------------------\n"
	DEBUG:			.asciiz "\nDEBUG\n"
	ENDL: 			.asciiz	"\n"
	SPACE: 			.asciiz " "
	TAB: 			.asciiz "\t"
	QUESTION:		.asciiz "?"
	
	ASK_NAME_PLAYER1:	.asciiz "Enter Player 1's name (below 20 letters):\t"
	ASK_NAME_PLAYER2: 	.asciiz "Enter Player 2's name (below 20 letters):\t"
	ASK_SYMBOL:		.asciiz ", you will play first! Please choose your symbol ('X' for X, press other key for O):\t"
	ASK_POSITION:		.asciiz ", which column do you want to go? (1-7)\t"
	ASK_UNDO_1:		.asciiz "You have "
	ASK_UNDO_2:		.asciiz " undos left. Do you want to undo? (Y for Yes, press any other key for No)\t"
	
	P1_symbol: 		.asciiz "X"
	P2_symbol:		.asciiz "O"
	BOARD_NUMBERING: 	.asciiz "\t\t   1     2     3     4     5     6     7\n"
	BOARD_HORIZONTAL:	.asciiz "\t\t___________________________________________\n"
	BOARD_EMPTY_1: 		.asciiz "\t\t|     |     |     |     |     |     |     |\n"
	BOARD_EMPTY_2: 		.asciiz "|  "
	BOARD_EMPTY_3:		.asciiz "|\n"
	BOARD_EMPTY_4: 		.asciiz "\t\t|_____|_____|_____|_____|_____|_____|_____|\n"
	SEPERATION:		.asciiz "\n__________________________________________________________________________________\n\n"
	
	CONGRATULATION:		.asciiz "\t\t           YOU HAVE WON, "
	GAME_DRAW:		.asciiz "\t\t                  GAME DRAW !!! "
	
	BEGIN:			.asciiz "LET'S GET STARTED !!"
	ERROR: 			.asciiz "[ERROR] "
	INVALID_INPUT_MSG:	.asciiz ", INVALID INPUT!!! You have "
	INVALID_INPUT_MSG_2:	.asciiz " chances left."
		
	
	# DATA STORAGE: Use to store allocated, memory 
	game_board: 	.word 0, 0, 0, 0, 0, 0, 0,  	# 42 slots * 4 bytes for integer = 168 bytes
			      0, 0, 0, 0, 0, 0, 0,	# Here we use the column major strategy, with the below formulae:
			      0, 0, 0, 0, 0, 0, 0,	# Address = baseAddress + (columnIndex * rowSize + rowIndex) * datasize
			      0, 0, 0, 0, 0, 0, 0,
			      0, 0, 0, 0, 0, 0, 0,
			      0, 0, 0, 0, 0, 0, 0
	
	len_list:	.word 0, 0, 0, 0, 0, 0, 0,	# We keep track of the length of each column so that
							# we could easily track user's violation
			      		      
	game_history: 	.space 168	# 42 slots storing maximum of 42 steps (1 for player 1 and 2 for player 2)
	
	session_count:	.word 1		# Number of rounds (from 1 to maximum capcity (42) )
	
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
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
	
		la 	$a0, WELCOME
		li 	$v0, 4			# Print String status code
		syscall 			# Print String
		
		la 	$a0, ENDL
		syscall				# Print String
		
		jal 	init_game		# Call to initialize the game by request necessary input from user
		
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
	# display_session (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Display the sesison of the game, including: game board and questions
	display_session:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		jal 	print_board
		
		jal 	handle_input_logic
		
		lw 	$t1, session_count
		addi 	$t1, $t1, 1
		sw	$t1, session_count
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
		
	# display_session (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Display victory pose, win, lose or draw
	display_end:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		la 	$a0, SEPERATION
		li 	$v0, 4			# Print String status code
		syscall 
		
		jal 	print_board
		
		la 	$a0, ENDL
		li 	$v0, 4
		syscall 
		
		lw 	$t1, status		# Hold the value of current_player
		beq	$t1, 0, Draw
		lw 	$t1, current_player		# Hold the value of current_player
		beq	$t1, 1, P2_won
			la 	$a0, CONGRATULATION
			li 	$v0, 4			# Print String status code
			syscall 
		
			la 	$a0, Player1
			li 	$v0, 4
			syscall
			j exit_won
		P2_won:
		
			la 	$a0, CONGRATULATION
			li 	$v0, 4			# Print String status code
			syscall 
			
			la 	$a0, Player2
			li 	$v0, 4
			syscall
			j exit_won
		Draw:
			la 	$a0, GAME_DRAW
			li 	$v0, 4			# Print String status code
			syscall 
		
		exit_won:
		
		
		la 	$a0, SEPERATION
		li 	$v0, 4			# Print String status code
		syscall 
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
	# print_board (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Print out the game board using 2 while loop
	print_board:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		li 	$v0, 4			# Print String
		
		la 	$a0, BOARD_NUMBERING
		syscall
		
		la 	$a0, BOARD_HORIZONTAL
		syscall
		
		# Traverse the game_board with i and j for every i in [0, 5] and j in [0, 6]
		lw 	$s2, ROW_SIZE		# row size
		lw 	$s3, COLUMN_SIZE		# column size
		
		addi	$s0, $0, 0			# int i = 0
		I_loop:
			slt	$s2, $s0, $s2		# while i < row size
			bne 	$s2, 1, exit_I_loop
			
			la 	$a0, BOARD_EMPTY_1
			syscall
			
			la 	$a0, TAB
			syscall
			syscall
			
			addi 	$s1, $0, 0			# int j = 0
			J_loop:
				slt 	$s3, $s1, $s3		# while j < column size
				bne 	$s3, 1, exit_J_loop
				
				la 	$a0, BOARD_EMPTY_2
				syscall
				
				add 	$a1, $zero, $s0
				add 	$a2, $zero, $s1
				jal	get_address		# Get Address and stores in $a0
					
				lw 	$a0, 0($a0)
				beq 	$a0, 1, if_player1_move
				beq	$a0, 2, if_player2_move
				la 	$a0, SPACE
				syscall
				j 	exit_branch
				if_player1_move:
					la 	$a0, P1_symbol
					syscall
					j 	exit_branch
				if_player2_move:
					la 	$a0, P2_symbol
					syscall
				exit_branch:
					
				la 	$a0, SPACE
				syscall
				syscall
					
				addi 	$s1, $s1, 1
				lw 	$s3, COLUMN_SIZE
				j J_loop
			exit_J_loop:
			
			la 	$a0, BOARD_EMPTY_3
			syscall
			
			la 	$a0, BOARD_EMPTY_4
			syscall
			
			lw 	$s3, COLUMN_SIZE
			addi 	$s0, $s0, 1
			lw 	$s2, ROW_SIZE
			j 	I_loop
		exit_I_loop:
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
	# clear*:
	
	# delay*:
	
	# GAME ENGINE
	
	# init_game (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Request necessary input from the user
	init_game:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		jal 	get_random_player	# Randomly choose 1 or 2 to $v0
		
		la 	$a0, ASK_NAME_PLAYER1
		li 	$v0, 4
		syscall				# Print String
		
		beq 	$t0, 1, P1_start
		la 	$a0, Player2		# String buffer
		j 	exit_start_1
		P1_start:
			la 	$a0, Player1	# String buffer
		exit_start_1:
		li 	$a1, 20			# Maximum character to read
		li 	$v0, 8			# Read String status code
		syscall				# Read String to Player1
		
		la 	$a0, ENDL
		li 	$v0, 4			# Print String status code
		syscall
		
		la 	$a0, ASK_NAME_PLAYER2
		syscall 			# Print String			
		
		beq 	$t0, 1, P1_start_2
		la 	$a0, Player1		# String buffer
		j exit_start_2
		P1_start_2:
			la 	$a0, Player2	# String buffer
		exit_start_2:
		li 	$a1, 20			# Maximum character to read
		li 	$v0, 8			# Read String status code
		syscall 			# Read String to Player2
		
		la 	$a0, ENDL
		li 	$v0, 4
		syscall
		
		# Delete the '\n' behind the name when input
		la 	$a0, Player1
		
		scanning_Player1:
			lb 	$t2, 0($a0)
			beq 	$t2, '\n', end_scanning_Player1
			addi 	$a0, $a0, 1
			j scanning_Player1
		end_scanning_Player1:
		sb $zero, 0($a0)
		
		la 	$a0, Player2
		
		scanning_Player2:
			lb 	$t2, 0($a0)
			beq 	$t2, '\n', end_scanning_Player2
			addi 	$a0, $a0, 1
			j scanning_Player2
		end_scanning_Player2:
		sb $zero, 0($a0)
		
		la 	$a0, Player1
		li 	$v0, 4
		syscall
		
		la	$a0, ASK_SYMBOL
		syscall
		
		li 	$v0, 12			# Read character
		syscall
	
		beq	$v0, 'X', p1_is_X
			# Swap character
			lb $t0, P1_symbol
			lb $t1, P2_symbol
			sb $t0, P2_symbol
			sb $t1, P1_symbol
		j p1_is_X
		p1_is_X:
		
		la 	$a0, ENDL
		li 	$v0, 4
		syscall
		
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
		
	# handle_input_logic (void)
	# Parameter Register: 	None
	# Return Register: 	None
	# Function: 		Handle input of position to join from the user
	handle_input_logic:
		subi 	$sp, $sp, 8
		sw	$s0, 4($sp)
		sw 	$ra, 0($sp)
		
		lw 	$s0, current_player		# Hold the value of current_player
		
		beq 	$s0, 2, P2_input_turn
		
		# Printing the message asking the user to input
		# Player's 1 turn
		la 	$a0, Player1
		li 	$v0, 4			# Print String status code
		syscall
		j exit_turn
		P2_input_turn:
		# Player's 2 turn
		la 	$a0, Player2
		li 	$v0, 4			# Print String status code
		syscall 
		exit_turn:
		
		la 	$a0, ASK_POSITION
		li 	$v0, 4			# Print String status code
		syscall
		
		li 	$v0, 5			# Read integer to $v0
		syscall
		move 	$t0, $v0		# input
		
		# Here we read the position until the position is correct, or the player's 
		# violation count is 0
		while_invalid_input:
			# Check violation
			# Here we need to check these conditions:
			# 	- If 0 < input < 8
			#	- If game_board[input].size() < 6
			# 	- If check len_list[input] >= 6
			condition1:
			slti	$t1, $t0, 1			# If the input is less than 1, try again
			bne	$t1, 1, condition2
			j 	continue_invalid_input
			condition2:
			slti 	$t1, $t0, 8			# If the input is more than 8, try again
			beq 	$t1, 1, condition3
			j 	continue_invalid_input
			condition3:				# Check len_list[input] >= 6
			la 	$t1, len_list
			add 	$t1, $t1, $t0
			add 	$t1, $t1, $t0
			add 	$t1, $t1, $t0
			add 	$t1, $t1, $t0
			subi 	$t1, $t1, 4
			lw 	$t2, 0($t1)
			bne 	$t2, 6, exit_invalid_input
			
			continue_invalid_input:
			
			# PRINT ERROR
			la 	$a0, ENDL
			li 	$v0, 4			# Print String status code
			syscall
			
			la 	$a0, ERROR
			li 	$v0, 4			# Print String status code
			syscall
			
			
			
			# Printing the message asking the user to input
			beq 	$s0, 2, P2_error_input_noti
			# Player's 1 turn
			la 	$a0, Player1
			li 	$v0, 4			# Print String status code
			syscall
			
			la 	$a0, INVALID_INPUT_MSG
			li 	$v0, 4			# Print String status code
			syscall
			
			lw	$t1, P1_violation
			subi	$t1, $t1, 1
			sw	$t1, P1_violation
			
			move	$a0, $t1
			li	$v0, 1
			syscall
			
			la 	$a0, INVALID_INPUT_MSG_2
			li 	$v0, 4			# Print String status code
			syscall
			
			la 	$a0, ENDL
			li 	$v0, 4			# Print String status code
			syscall
			syscall
			
			bne	$t1, 0, P2_not_won
			addi 	$t1, $0, 2
			sw	$t1, status
			j 	exit_change
			P2_not_won:
			
			j exit_error_input_noti
			P2_error_input_noti:
			# Player's 2 turn
			la 	$a0, Player2
			li 	$v0, 4			# Print String status code
			syscall 
			la 	$a0, INVALID_INPUT_MSG
			li 	$v0, 4			# Print String status code
			syscall
			
			lw	$t1, P2_violation
			subi	$t1, $t1, 1
			sw	$t1, P2_violation
			
			move	$a0, $t1
			li	$v0, 1
			syscall
			
			la 	$a0, INVALID_INPUT_MSG_2
			li 	$v0, 4			# Print String status code
			syscall
			
			la 	$a0, ENDL
			li 	$v0, 4			# Print String status code
			syscall
			syscall
			
			bne	$t1, 0, P1_not_won
			addi 	$t1, $0, 1
			sw	$t1, status
			j 	exit_change
			P1_not_won:
			
			exit_error_input_noti:
		
			beq 	$s0, 2, P2_input_turn_invalid_input
			
			# Printing the message asking the user to input
			# Player's 1 turn
			la 	$a0, Player1
			li 	$v0, 4			# Print String status code
			syscall
			j exit_turn_invalid_input
			P2_input_turn_invalid_input:
			# Player's 2 turn
			la 	$a0, Player2
			li 	$v0, 4			# Print String status code
			syscall 
			exit_turn_invalid_input:
			
			la 	$a0, ASK_POSITION
			li 	$v0, 4			# Print String status code
			syscall
			
			li 	$v0, 5			# Read integer to $v0
			syscall
			move 	$t0, $v0		# input
			
			j while_invalid_input
		exit_invalid_input:
		
		move 	$a0, $t0		# Parameter: column + 1
		move 	$a1, $s0		# Parameter: player[1, 2]
		subi 	$a0, $a0, 1		# column -= 1
		jal 	insert_column		# Function call to insert to the matrix, return $a1: row, $a2: column
						# for the next function
	
		move 	$a0, $s0		# Parameter: player[1, 2]
		jal 	check_win		# Function call to check win or not, return value will be in $v0
		move 	$t1, $v0
		
		# Change the status if one player won
		beq	$t1, 0, not_win
		sw	$s0, status
		j no_undo
		not_win:
		
		# Check if both players has moved
		lw	$t1, session_count
		slti	$t1, $t1, 3
		beq	$t1, 1, no_undo
		
		# Ask the player whether they want to undo
		beq 	$s0, 2, P2_undo
			lw 	$t1, P1_undo_count
			
			beq	$t1, 0, no_undo
			
			la 	$a0, ASK_UNDO_1
			li 	$v0, 4			# Print String status code
			syscall
			
			move 	$a0, $t1
			li 	$v0, 1
			syscall
			
			la 	$a0, ASK_UNDO_2
			li 	$v0, 4			# Print String status code
			syscall
			
			li	$v0, 12			# Read character
			syscall
			
			bne	$v0, 'Y', no_undo	# If user don't want to undo, continue
			
			# UNDO
			subi 	$t1, $t1, 1
			sw	$t1, P1_undo_count
			
			la	$t3, game_history
			sll	$a2, $a2, 2
			add 	$t3, $t3, $a2
			srl	$a2, $a2, 2
			lw	$t2, 0($t3)
			
			# Delete from gameboard
			
			sw 	$zero, 0($t2)
			
			lw 	$t1, session_count
			subi 	$t1, $t1, 1
			sw	$t1, session_count
			j 	exit_change
			
			
		P2_undo:
			lw 	$t1, P2_undo_count
			
			beq	$t1, 0, no_undo
			
			la 	$a0, ASK_UNDO_1
			li 	$v0, 4			# Print String status code
			syscall
			
			move 	$a0, $t1
			li 	$v0, 1
			syscall
			
			la 	$a0, ASK_UNDO_2
			li 	$v0, 4			# Print String status code
			syscall
			
			li	$v0, 12			# Read character
			syscall
			
			bne	$v0, 'Y', no_undo	# If user don't want to undo, continue
			
			
			subi 	$t1, $t1, 1
			sw	$t1, P2_undo_count
			
			la	$t3, game_history
			sll	$a2, $a2, 2
			add 	$t3, $t3, $a2
			srl	$a2, $a2, 2
			lw	$t2, 0($t3)
			
			# Delete from gameboard
			
			sw 	$zero, 0($t2)
			
			lw 	$t1, session_count
			subi 	$t1, $t1, 1
			sw	$t1, session_count
			j	exit_change
		no_undo:
			
			beq 	$s0, 2, P2_change
			# Player's 1 turn
			addi 	$s0, $0, 2		# Set current_player from 2 to 1
			sw 	$s0, current_player 
			j 	exit_change
			P2_change:
			# Player's 2 turn
			addi 	$s0, $0, 1		# Set current_player from 2 to 1
			sw 	$s0, current_player
			exit_change:
			
		la 	$a0, ENDL
		li 	$v0, 4			# Print String status code
		syscall
		
		
		lw 	$ra, 0($sp)
		lw	$s0, 4($sp)
		addi 	$sp, $sp, 8
		jr 	$ra
	
	# insert_column (coordinate)
	# Parameter Register: 	$a0: column, $a1: player
	# Return Register: 	$a1: row, $a2: column
	# Function: 		Insert the coin to the right position, increase len_list[$a0]
	# Algorithm:		
	insert_column:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		# Main insert algorithm
		addi 	$t0, $0, 1		# row = 0
		move 	$t1, $a0		# column = 0
		move 	$t3, $a1		# player 1 or player 2
		
		probing_loop:
			beq 	$t0, 6, exit_probing
			
			move	$a1, $t0
			move	$a2, $t1
			jal	get_address	# Function call get the address of [a1][a2]
			lw 	$t2, 0($a0)
			
			bne	$t2, 0, exit_probing
			
			addi 	$t0, $t0, 1
			j probing_loop
			
		exit_probing:
		subi	$t0, $t0, 1
		move	$a1, $t0	# row
		move	$a2, $t1	# column
		jal	get_address	# Function call get the address of [a1][a2] and return to $a0
		
		# Save the position
		add 	$t2, $zero, $t3 
		sw 	$t2, 0($a0)
		
		# Add the address to game_history
		la	$t3, game_history
		sll	$t1, $t1, 2
		add 	$t3, $t3, $t1
		srl	$t1, $t1, 2
		sw 	$a0, 0($t3)
		
		# Append len_list
		la 	$t0, len_list
		addi 	$t2, $t1, 0
		sll	$t2, $t2, 2
		add 	$t0, $t0, $t2
		lw 	$t2, 0($t0)
		addi	$t2, $t2, 1
		sw	$t2, 0($t0)
		
		addi 	$t1, $t1, 1
		move 	$a0, $t1
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
		
	# check_win (bool)
	# Parameter Register: 	$a0: holding value, $a1: row, $a2: column
	# Return Register: 	$v0
	# Function: 		Check if the player has win or not and return 0 for false and 1 for true:		
	check_win:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		move	$t1, $a1		# row
		move 	$t2, $a2		# column
		move	$t3, $a0		# holding value
		
		# VERTICAL
		# Algorithm
		addi 	$t0, $0, 0		# Count var
		vertical_down_check:
			beq	$a1, 6, exit_vert_down_check 	# if i == 6 break
			beq 	$a2, 7, exit_vert_down_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_vert_down_check
			
			addi 	$t0, $t0, 1
			addi 	$a1, $a1, 1
			j 	vertical_down_check
		exit_vert_down_check:
		
		slti	$t0, $t0, 4
		beq 	$t0, 1, not_vert
		add 	$v0, $0, 1
		j 	check_return
		not_vert:
		
		move 	$a1, $t1
		move 	$a2, $t2
		
		# HORIZONTAL
		# Algorithm
		addi 	$t0, $0, 0		# Count var
		
		addi 	$a2, $a2, 1
		horizontal_right_check:
			beq	$a1, 6, exit_hori_right_check 	# if i == 6 break
			beq 	$a2, 7, exit_hori_right_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_hori_right_check
			
			addi 	$t0, $t0, 1
			addi 	$a2, $a2, 1
			j 	horizontal_right_check
		exit_hori_right_check:
		
		move 	$a1, $t1
		move 	$a2, $t2
		horizontal_left_check:
			beq	$a1, -1, exit_hori_left_check 	# if i == 6 break
			beq 	$a2, -1, exit_hori_left_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_hori_left_check
			
			addi 	$t0, $t0, 1
			subi 	$a2, $a2, 1
			j 	horizontal_left_check
		exit_hori_left_check:
		
		slti	$t0, $t0, 4
		beq 	$t0, 1, not_hori
		add 	$v0, $0, 1
		j 	check_return
		not_hori:
			
		move 	$a1, $t1
		move 	$a2, $t2
		
		# MAIN DIAGONAl
		# Algorithm 
		addi 	$t0, $0, 0		# Count var
		
		addi 	$a1, $a1, 1
		addi 	$a2, $a2, 1
		main_diagonal_up_check:
			beq	$a1, 6, exit_main_diagonal_up_check 	# if i == 6 break
			beq 	$a2, 7, exit_main_diagonal_up_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_main_diagonal_up_check
			
			addi 	$t0, $t0, 1
			addi 	$a1, $a1, 1
			addi 	$a2, $a2, 1
			j 	main_diagonal_up_check
		exit_main_diagonal_up_check:
		
		move 	$a1, $t1
		move 	$a2, $t2
		main_diagonal_down_check:
			beq	$a1, -1, exit_main_diagonal_down_check 	# if i == 6 break
			beq 	$a2, -1, exit_main_diagonal_down_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_main_diagonal_down_check
			
			addi 	$t0, $t0, 1
			subi 	$a1, $a1, 1
			subi 	$a2, $a2, 1
			j 	main_diagonal_down_check
		exit_main_diagonal_down_check:
		
		slti	$t0, $t0, 4
		beq 	$t0, 1, not_main_diagonal
		add 	$v0, $0, 1
		j 	check_return
		not_main_diagonal:
		
		move 	$a1, $t1
		move 	$a2, $t2
		
		# SUB DIAGONAl
		# Algorithm 
		addi 	$t0, $0, 0		# Count var
		
		addi 	$a1, $a1, 1
		subi 	$a2, $a2, 1
		sub_diagonal_up_check:
			beq	$a1, 6, exit_sub_diagonal_up_check 	# if i == 6 break
			beq 	$a2, -1, exit_sub_diagonal_up_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_sub_diagonal_up_check
			
			addi 	$t0, $t0, 1
			addi 	$a1, $a1, 1
			subi 	$a2, $a2, 1
			j 	sub_diagonal_up_check
		exit_sub_diagonal_up_check:
		
		move 	$a1, $t1
		move 	$a2, $t2
		sub_diagonal_down_check:
			beq	$a1, -1, exit_sub_diagonal_down_check 	# if i == 6 break
			beq 	$a2, 7, exit_sub_diagonal_down_check	# if j == 7 break
			
			jal 	get_address
			lw	$a0, 0($a0)
			bne 	$a0, $t3, exit_sub_diagonal_down_check
			
			addi 	$t0, $t0, 1
			subi 	$a1, $a1, 1
			addi 	$a2, $a2, 1
			j 	sub_diagonal_down_check
		exit_sub_diagonal_down_check:
		
		slti	$t0, $t0, 4
		beq 	$t0, 1, not_sub_diagonal
		add 	$v0, $0, 1
		j 	check_return
		not_sub_diagonal:
		
		move 	$a1, $t1
		move 	$a2, $t2
		
		add 	$v0, $0, 0
		
		check_return:
		move	$a1, $t1
		move	$a2, $t2
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
	
	# UTILITY
	
	# get_random_player (int)
	# Parameter Register: 	None
	# Return Register: 	$v0
	# Function: 		Pseudo-randomly choose player 1 or 2 start first (is X, the other is Y). 
	#			Return 1 for Player 1 and 2 for Player 2
	get_random_player:
		subi 	$sp, $sp, 4
		sw 	$ra, 0($sp)
		
		addi 	$a0, $0, 2		# i.d. return value
		addi 	$a1, $0, 2		# Range
		li 	$v0, 42        		# Get random number in range [int] 
    		syscall
    		
    		add 	$a0, $a0, 1		# increase range from [0, 1] to [1, 2]
    		move 	$v0, $a0
		
		lw 	$ra, 0($sp)
		addi 	$sp, $sp, 4
		jr 	$ra
		
	# get_address (int)
	# Parameter Register: 	$a1, $a2
	# Return Register: 	$a0
	# Function: 		Return the address of the coordinate ($a1, $a2) on the board 
	#			base one the formula [Address = baseAddress + (rowIndex * columnSize + columnIndex) * datasize]
	get_address:
		subi 	$sp, $sp, 8
		sw 	$s0, 4($sp)
		sw 	$ra, 0($sp)
		
		lw 	$s0, COLUMN_SIZE	# Loading COLUMN_SIZE
		mul 	$a0, $a1, $s0		# Perform rowIndex * columnSize
		add 	$a0, $a0, $a2		# Perform rowIndex * columnSize + columnIndex
		sll 	$a0, $a0, 2		# Perform (rowIndex * columnSize + columnIndex) * 4
		la 	$s0, game_board		# Loading game_board address
		add 	$a0, $a0, $s0		# Perform Address = baseAddress + (rowIndex * columnSize + columnIndex) * datasize
		
		lw 	$ra, 0($sp)
		lw 	$s0, 4($sp)
		addi 	$sp, $sp, 8
		jr 	$ra
	main:
		jal display_start		# Display the start screen
		
		session_loop:
			lw 	$t0, status			# Check status if not 0 then exit
			bne 	$t0, 0, exit_session_loop
			lw 	$t0, session_count		# Check session_count if number of moves exceed 42
			beq 	$t0, 43, exit_session_loop
			
			jal 	display_session
			
			j 	session_loop
		exit_session_loop:
		
		jal display_end
		
		# Close the program
		li $v0, 10
        	syscall
