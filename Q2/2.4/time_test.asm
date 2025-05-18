main:
	csrr s1,3074   # le o num instr atual 
	csrr s0,3073   # le o time atual 
	
	jal ff1
	
	csrr t0,3073   # le o time atual 
	csrr t1,3074   # le o num instr atual 
	
	li a7, 1
	sub a0,t0,s0   # calcula o tempo de execução Texec em ms 
	ecall
	sub a0,t1,s1
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	ecall

	csrr s1,3074   # le o num instr atual 
	csrr s0,3073   # le o time atual 
	
	jal ff2
	
	csrr t0,3073   # le o time atual 
	csrr t1,3074   # le o num instr atual 
	
	li a7, 1
	sub a0,t0,s0   # calcula o tempo de execução Texec em ms 
	ecall
	sub a0,t1,s1
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	ecall
	
	csrr s1,3074   # le o num instr atual 
	csrr s0,3073   # le o time atual 
	
	jal ff3
	
	csrr t0,3073   # le o time atual 
	csrr t1,3074   # le o num instr atual 
	
	li a7, 1
	sub a0,t0,s0   # calcula o tempo de execução Texec em ms 
	ecall
	sub a0,t1,s1
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	ecall
	
	csrr s1,3074   # le o num instr atual 
	csrr s0,3073   # le o time atual 
	
	jal ff4
	
	csrr t0,3073   # le o time atual 
	csrr t1,3074   # le o num instr atual 
	
	li a7, 1
	sub a0,t0,s0   # calcula o tempo de execução Texec em ms 
	ecall
	sub a0,t1,s1
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	ecall
	
	csrr s1,3074   # le o num instr atual 
	csrr s0,3073   # le o time atual 
	
	jal ff5
	
	csrr t0,3073   # le o time atual 
	csrr t1,3074   # le o num instr atual 
	
	li a7, 1
	sub a0,t0,s0   # calcula o tempo de execução Texec em ms 
	ecall
	sub a0,t1,s1
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	ecall

	csrr s1,3074   # le o num instr atual 
	csrr s0,3073   # le o time atual 
	
	jal ff6
	
	csrr t0,3073   # le o time atual 
	csrr t1,3074   # le o num instr atual 
	
	li a7, 1
	sub a0,t0,s0   # calcula o tempo de execução Texec em ms 
	ecall
	sub a0,t1,s1
	ecall
	li a0, '\n'
	li a7, 11
	ecall
	ecall
li a7, 10
ecall

ff1:
        slli    a0,a0,2
        ret
ff2:
        slli    a0,a0,2
        ret
ff3:
        slli    a0,a0,2
        ret
ff4:
        slli    a0,a0,2
        ret
ff5:
        slli    a0,a0,2
        ret
ff6:
        fcvt.d.w        fa5,a0
        lui     a5,%hi(.LC0)
        fld     fa4,%lo(.LC0)(a5)
        fmul.d  fa5,fa5,fa4
        fcvt.w.d a0,fa5,rtz
        ret
        
.data
.LC0:
        .word   0
        .word   1074790400