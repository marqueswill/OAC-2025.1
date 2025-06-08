.text
	addi a0,x0,6
	
	addi t0, x0, 1
	add s0, x0, x0
	
	jal ra, Fibonacci
	j print
	
	
	Fibonacci:
	slt t1, t0, a0
        beq t1, x0, CasoBase
	addi sp, sp, -8
	sw ra, 0(sp)
	sw a0, 4(sp)
	addi a0, a0, -1
	jal ra, Fibonacci
	
	lw a1, 4(sp)
	sw a0, 4(sp)
	addi a0, a1, -2
	jal ra, Fibonacci
	lw a1, 4(sp)
	add a0, a0, a1
	lw ra, 0(sp)
	addi sp, sp, 8 
	
	CasoBase:
	#jalr x0,x1,0
	jr ra
	print:
	
	addi t1, t1, 7
	sub a0, a0, t1 # 1
	and a0, a0, a0 # 1
	or  a0, a0, a0 # 1
