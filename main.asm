.include "winCheck.asm"
.globl printDraw
.globl getAt
.globl printWin
.globl printLose
.data 
#Board Characters
playerCell: .asciiz "|X"
blankCell:  .asciiz "|_"
compCell:   .asciiz "|O"
ender:      .asciiz "|\n"
newLine:    .asciiz "\n"
#Array
array:      .word 0, 0, 0, 0, 0, 0, 0
	    .word 0, 0, 0, 0, 0, 0, 0
	    .word 0, 0, 0, 0, 0, 0, 0
	    .word 0, 0, 0, 0, 0, 0, 0
	    .word 0, 0, 0, 0, 0, 0, 0
	    .word 0, 0, 0, 0, 0, 0, 0
ROW_SIZE:   .word 6
COL_SIZE:   .word 7
.eqv DATA_SIZE 4
		 
#Prompts
prEntry:    .asciiz "Enter number for column: (1-7)\n"
prWelc:	    .asciiz "Welcome to Connect 4!\n"
printW:     .asciiz "Congrats! You win!\n"
printL:     .asciiz "Oh no, you lost :(\n"
printD:     .asciiz "Draw, full boardstate\n"
printE:     .asciiz "Error!"
printInE:   .asciiz "Input not valid, please try again!\n"
#Variables
colIndex:    .word 0

.text
.globl main
main:
#Print Welcome Message
li $v0, 4
la $a0, prWelc
syscall

     
inputLoop:
# Print input prompt
     li $v0, 4
     la $a0, prEntry
     syscall             
# Take input    
     li $v0, 5            
     syscall
# Adjust input and save --> coloumn
     addi $v0, $v0, -1    
     sw   $v0, colIndex              
# Check for invalid input
     lw $a3, colIndex	
     jal validInput	   
# Upload to Array
     addi $a2, $0, -1			# row index set to -1
     jal addValUser				# add to array(next available row)	
cont:
#Check for use win
jal checkHorizontal
jal checkVertical
jal checkDiagonalOne
jal checkDiagonalTwo
jal checkDraw
cont3:  
# Computer Randomized Turn
     j addValComp
cont2:
jal print
# Check for win
	# computer win
jal checkHorizontal
jal checkVertical
jal checkDiagonalOne
jal checkDiagonalTwo
jal checkDraw
# Start loop again
j inputLoop
# Jump Terminate
j Exit



printWin:
li $v0, 4
la $a0, printW
syscall
jal print
li $v0, 10
syscall

printLose:
li $v0, 4
la $a0, printL
syscall
jal print
li $v0, 10
syscall

addValComp:
     
     li $v0, 42         # call for random number
     li $a1, 6          # sets upper bound to 6 
     syscall		# results in $a0(0-6)
     move $a3, $a0	# save result
     addi $a2, $0, 5
     
     #la $a0, array
     jal getAt
     bnez $v0, addValComp	#if invalid coloumn, get new random number
     li $a2, -1
     compLoop:
     addi $a2, $a2, 1     
     #la $a0, array
     #lw $a1, COL_SIZE
     jal getAt
     bne $v0, $0, compLoop
     addi $t0, $0, 2
     sw $t0, ($v1)
     j cont2
     
jal getAt		#result in $v0, address in $v1
bne $v0, $0, addValUser
# set arguments before call
addi $t0, $0, 1    
sw $t0, ($v1)
j cont2


addValUser:	#$a0 -> base addr, $a1 -> COL_SIZE,  $a2 -> row index,  $a3 -> coloumn index, 	
addi $a2, $a2, 1
#move $s0, $ra
lw $a3, colIndex
jal getAt		#result in $v0, address in $v1
bne $v0, $0, addValUser
#move $ra, $s0
# set arguments before call
addi $t0, $0, 1    
sw $t0, ($v1)
j cont

# Check Valid Input
validInput:				
# If input <1 or >7, try again
     bgt  $a3, 6, inputError
     blt  $a3, 0, inputError
# Check if coloumn is full		(getAt function) $a0 -> base addr, $a1 -> COL_SIZE,  ,  $a3 -> coloumn index
     addi $a2, $0, 5			# row index into $a2
     move $s0, $ra
     jal getAt
     # result in $v0
     move $ra, $s0
     bnez $v0, inputError		# if value is not ZERO (empty), then retake input
     jr $ra				# else continue program
     
# Terminate Program
Exit:
     li $v0, 10
     syscall
     
inputError:
     li $v0, 4
     la $a0, printInE
     syscall
     j inputLoop
    
getAt:				#$a2 -> row index,  $a3 -> coloumn Index
# save $t0
move $s1, $t0
# clear $t0
add $t0, $t0, $0
# load constants
la $a0, array
lw $a1, COL_SIZE
# math to get array val/address
     mul $t0, $a1, $a2 		        # row index * COL_SIZE
     add $t0, $t0, $a3			# + coloumnIndex
     mul $t0, $t0, DATA_SIZE		# * Data Size
     add $t0, $t0, $a0			# + base addr
     lw  $v0, ($t0)			# value in $v0
     la  $v1, ($t0)			# address in #v1
     # restore $t0
move $t0, $s1
# jump back
     jr  $ra				


print:	#t2 = -1
move $s0, $ra
addi $t2, $zero, 6
printLoop:
addi $t0, $zero, -1 	
addi $t2, $t2, -1     	# t2 -> row tracker
sgt $t3, $t2, 0
firstLoop:
addi $t0, $t0, 1	# t0 -> coloumn tracker
slti $t1, $t0, 6

# print appropriate cell
# set up arguments ($a2 = row index(t2), $a3 = coloumn index(t1))
add $a2, $t2, $0
add $a3, $t0, $0
jal getAt			#value in $v0
beqz $v0, printBlank
addi $t5, $0, 1
addi $t6, $0, 2
beq  $v0, $t5, printUser
beq  $v0, $t6, printComp
continue:

bne $t1, $zero, firstLoop

li $v0, 4
la $a0, ender
syscall

bne $t3, $zero, printLoop

move $ra, $s0
jr $ra

printBlank:
li $v0, 4
la $a0, blankCell
syscall
j continue

printUser:
li $v0, 4
la $a0, playerCell
syscall
j continue

printComp:
li $v0, 4
la $a0, compCell
syscall
j continue

printDraw:
li $v0, 4
la $a0, printD
syscall