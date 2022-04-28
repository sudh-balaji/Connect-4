CheckDraw:
# save $ra, val
move $s2, $ra
# set row index
addi $a2, $0, -1
rowLoop5:
	#$t0 tracks sum
	add $t0, $0, $0
	#increment row index
	addi $a2, $a2, 1
	#set column index
	addi $a3,$0, -1
	# if row is less than 6, continue
	bne $a2, 6, colLoop5
	# otherwise restore $ra and exit loop
	move $ra, $s2
	jr $ra
colLoop5:
beq $a3,7,rowLoop5
addi $a3, $a3, 1
jal getAt
bne $v0,0,colLoop5
addi $t0,$t0,1
beq $t0,1, printDraw
j colLoop5