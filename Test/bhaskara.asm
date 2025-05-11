.data
input_vector: .space 12

.text
.globl main

main:
	jal read_input

	la t0, input_vector
	flw fa0, 0(t0)
	flw fa1, 4(t0)
	flw fa2, 8(t0)
	jal bhaskara

	li a7, 10
	ecall

read_input:
	la t0, input_vector

	li a7, 6             
	ecall
	fsw fa0, 0(t0)

	li a7, 6
	ecall
	fsw fa0, 4(t0)   

	li a7, 6
	ecall
	fsw fa0, 8(t0)
	
	ret

# fa0 = a, fa1 = b, fa2 = c
bhaskara: 
	addi sp, sp, -12
	sw ra, 0(sp)
	sw s0, 4(sp) # x1
	sw s1, 8(sp) # x2

	jal bhaskara_delta

	li t0, 4
	fcvt.s.w ft1, t0
	flt.s t0, fa0, ft1
	bnez t0, bhaskara_complexas

	bhaskara_reais:
		li a0, 1
		# todo: calcular raízes reais
		j bhaskara_end

	bhaskara_complexas:
		li a0, 2
		# todo: calcular raízes complexas
		j bhaskara_end

	# todo: descobrir em que casos ocorre o erro
	bhaskara_erro:
		li a0, 0
		j bhaskara_end

	bhaskara_end:
		mv s0, t0
		mv s1, t1
		
		lw ra, 0(sp)
		lw s0, 8(sp)
		lw s1, 4(sp)
		addi sp, sp, 12
		
		sw t0, 0(sp)
		sw t1, 4(sp)

		ret

	# a0 = [a, b, c]
	bhaskara_delta:
		fmul.s ft0, fa1, fa1 # b^2
		
		li t1, 4
		fcvt.s.w ft1, t1
		
		fmul.s ft1, ft1, fa0 # 4a
		fmul.s ft1, ft1, fa2 #4ac
		
		fsub.s fa0, ft0, ft1
		
		# test	
		#li a7, 2
		#ecall
		
		ret
	
