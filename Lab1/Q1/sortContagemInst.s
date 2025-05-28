.eqv N 30

.data
Vetor:  .word 9,2,5,1,8,2,4,3,6,7,10,2,32,54,2,12,6,3,1,78,54,23,1,54,2,65,3,6,55,31

.text	
MAIN:	la a0,Vetor
	li a1,N
	jal SHOW

	la a0,Vetor
	li a1,N
	
 	csrr s1,3074   # le o num instr atual
      	csrr s0,3073   # le o time atual
      	
      	#s5 para I
      	add s5,zero,zero
      	#s6 para R
      	add s6,zero,zero
      	#s7 para B
      	add s7,zero,zero
      	#s8 para J
      	add s8,zero,zero
      	#s9 para S
      	add s9,zero,zero

	jal SORT

      	csrr t0,3073   # le o time atual
      	csrr t1,3074   # le o num instr atual
     	sub s0,t0,s0   # calcula o tempo de execução Texec em ms
     	sub s1,t1,s1   # calcula o número de instruções I executadas
     	


	la a0,Vetor
	li a1,N
	jal SHOW


	li a7,10
	ecall


SWAP:	addi s5,s5,1
	slli t1,a1,2 #I
	addi s6,s6,1
	add t1,a0,t1 #R
	addi s5,s5,1
	lw t0,0(t1) #I
	addi s5,s5,1
	lw t2,4(t1) #I
	addi s9,s9,1
	sw t2,0(t1) #S
	addi s9,s9,1
	sw t0,4(t1) #S
	addi s5,s5,1
	ret #I

SORT:	addi s5,s5,1
	addi sp,sp,-20 #I
	addi s9,s9,1
	sw ra,16(sp)#S
	addi s9,s9,1
	sw s3,12(sp)#S
	addi s9,s9,1
	sw s2,8(sp)#S
	addi s9,s9,1
	sw s1,4(sp)#S
	addi s9,s9,1
	sw s0,0(sp)#S
	addi s6,s6,1
	mv s2,a0#R
	addi s6,s6,1
	mv s3,a1#R
	addi s6,s6,1
	mv s0,zero#R
for1:	addi s7,s7,1
	bge s0,s3,exit1#B
	addi s5,s5,1
	addi s1,s0,-1#I
for2:	addi s7,s7,1
	blt s1,zero,exit2#B
	addi s5,s5,1
	slli t1,s1,2#I
	addi s6,s6,1
	add t2,s2,t1#R
	addi s5,s5,1
	lw t3,0(t2)#I
	addi s5,s5,1
	lw t4,4(t2)#I
	addi s7,s7,1
	bge t4,t3,exit2#B
	addi s6,s6,1
	mv a0,s2#R
	addi s6,s6,1
	mv a1,s1#R
      	addi s8,s8,1
	jal SWAP#J
	addi s5,s5,1
	addi s1,s1,-1#I
	addi s8,s8,1
	j for2#J
exit2:	addi s5,s5,1
	addi s0,s0,1#I
	addi s8,s8,1
	j for1#J
exit1: 	addi s5,s5,1
	lw s0,0(sp)#I
	addi s5,s5,1
	lw s1,4(sp)#I
	addi s5,s5,1
	lw s2,8(sp)#I
	addi s5,s5,1
	lw s3,12(sp)#I
	addi s5,s5,1
	lw ra,16(sp)#I
	addi s5,s5,1
	addi sp,sp,20#I
	addi s5,s5,1
	ret#I

SHOW:	mv t0,a0
	mv t1,a1
	mv t2,zero

loop1: 	beq t2,t1,fim1
	li a7,1
	lw a0,0(t0)
	ecall
	li a7,11
	li a0,9
	ecall
	addi t0,t0,4
	addi t2,t2,1
	j loop1

fim1:	li a7,11
	li a0,10
	ecall
	ret
