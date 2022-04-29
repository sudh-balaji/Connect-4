.data
.text
checkDraw:
move $s2, $ra
addi $a2, $0, -1	# row
rowLoop5:
	addi $a2, $a2, 1
	addi $a3, $0, -1	# column
	bne $a2, 6, colLoop5	# keep going until row = 6
	j printDraw		# if loop ends, print draw
	colLoop5:
	beq $a3, 7, rowLoop5	# keep going until column = 7
	addi $a3, $a3, 1	# increment column
	jal getAt		# value in $v0
	beq $v0, 0, return	# if value is 0, return back to main
	j colLoop5
return:
move $ra, $s2
jr $ra	
	
checkDiagonalTwo:
move $s2, $ra
# set col index
addi $a3, $0, -1
colLoop4:
	# increment col index
	addi $a3, $a3, 1
	# set row index
	addi $a2, $0, 2
	# if coloumn != 7, continue code
	bne $a3, 7, rowLoop4
	# otherwise, exit loop
	move $ra, $s2
	jr $ra	
	rowLoop4:
		beq $a2, 6, colLoop4	# if row 6, increment coloumn
		addi $a2, $a2, 1
		jal getAt
		beqz $v0, rowLoop4	# if '0', go next
		add $t0, $v0, $0	# stores sum
		add $t3, $0, $0		# nextThree tracker
		nextThree4:
			addi $t3, $t3, 1
			addi $v1, $v1, -24
			lw $t1, ($v1)
			beqz $t1, rowLoop4	# if come across 0, check next
			add $t0, $t0, $t1
			beq $t3, 3, check4
			j nextThree4
		
check4:	
# if sum is 4, print user win and end
beq $t0, 4, printWin
# if sum is 8, print comp win and end
beq $t0, 8, printLose
# else keep checking
j rowLoop4

checkDiagonalOne:
move $s2, $ra
# set col index
addi $a3, $0, -1
colLoop3:
	# increment col index
	addi $a3, $a3, 1
	# set row index
	addi $a2, $0, -1
	# if coloumn != 7, continue code
	bne $a3, 7, rowLoop3
	# otherwise, exit loop
	move $ra, $s2
	jr $ra	
	rowLoop3:
		beq $a2, 3, colLoop3	# if row 3, increment
		addi $a2, $a2, 1
		jal getAt
		beqz $v0, rowLoop3	# if '0', go next
		add $t0, $v0, $0	# stores sum
		add $t3, $0, $0		# nextThree tracker
		nextThree3:
			addi $t3, $t3, 1
			addi $v1, $v1, 32
			lw $t1, ($v1)
			beqz $t1, rowLoop3	# if come across 0, check next
			add $t0, $t0, $t1
			beq $t3, 3, check3
			j nextThree3
		
check3:	
# if sum is 4, print user win and end
beq $t0, 4, printWin
# if sum is 8, print comp win and end
beq $t0, 8, printLose
# else keep checking
j rowLoop3

checkVertical:
move $s2, $ra
# set col index
addi $a3, $0, -1
colLoop2:
	# increment col index
	addi $a3, $a3, 1
	# set row index
	addi $a2, $0, -1
	# if coloumn != 7, continue code
	bne $a3, 7, rowLoop2
	# otherwise, exit loop
	move $ra, $s2
	jr $ra	
	rowLoop2:
		beq $a2, 3, colLoop2	# if row 3, 
		addi $a2, $a2, 1
		jal getAt
		beqz $v0, rowLoop2	# if '0', go next
		add $t0, $v0, $0	# stores sum
		add $t3, $0, $0		# nextThree tracker
		nextThree2:
			addi $t3, $t3, 1
			addi $v1, $v1, 28
			lw $t1, ($v1)
			beqz $t1, rowLoop2	# if come across 0, check next
			add $t0, $t0, $t1
			beq $t3, 3, check2
			j nextThree2
		
check2:	
# if sum is 4, print user win and end
beq $t0, 4, printWin
# if sum is 8, print comp win and end
beq $t0, 8, printLose
# else keep checking
j rowLoop2
	
checkHorizontal:
# set constants for use ($t4 -> 3, $t5 -> 4, $t6 -> 8)		
addi $t4, $0, 3		# constant var for nextThree label comparison
# save $ra val
move $s2, $ra
# set row index
addi $a2, $0, -1		# row index
rowLoop:
	# $t0 tracks sum (reset before each coloumn iteration)
	add $t0, $0, $0
	# increment row index
	addi $a2, $a2, 1
	# set coloumn index
	addi $a3, $0, -1
	# if row != 6, continue code 	
	bne $a2, 6, colLoop	
	# otherwise, restore $ra and exit loop
	move $ra, $s2
	jr $ra

colLoop:
beq $a3, 3, rowLoop	#increment row
addi $a3, $a3, 1	# increment coloumn
jal getAt		# return value in $v0
beqz $v0, colLoop	# if value = 0, check next
add $t0, $v0, $0	# store val in $t0 
add $t3, $0, $0		# tracker for nextThree 
	nextThree:
	addi $t3, $t3, 1
	addi $v1, $v1, 4
	lw $t1, ($v1)
	beqz $t1, colLoop	# if come across 0, check next
	add $t0, $t0, $t1
	beq $t3, 3, check
	j nextThree
check:
# if sum is 4, print user win and end
beq $t0, 4, printWin
# if sum is 8, print comp win and end
beq $t0, 8, printLose
# else keep checking
j colLoop
