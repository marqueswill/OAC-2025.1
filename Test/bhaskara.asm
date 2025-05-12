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
	addi sp, sp, -20
	sw ra, 0(sp)
	fsw fs0, 4(sp)  # a
	fsw fs1, 8(sp)  # b
	fsw fs2, 12(sp) # c
	fsw fs3, 16(sp) # x1
	fsw fs4, 20(sp) # x2
	
	fmv.s fs0, fa0
	fmv.s fs1, fa1
	fmv.s fs2, fa2

	jal bhaskara_delta # fa0 = delta

	li t0, 0
	fcvt.s.w ft0, t0
	flt.s t0, fa0, ft0
	bnez t0, bhaskara_complexas # delta < 0


	bhaskara_reais:
		# todo: calcular raízes reais
		fsqrt.s ft0, fa0  # ft0 = sqrt(delta)
		
		li t0, 2
		fcvt.s.w ft1, t0
		fmul.s  ft1, ft1, fs0 # ft1 = 2a 
		
		li a7, 2

		# raiz x1
		fneg.s fs3, fs1 # fs4 = -b
		fsub.s fs3, fs3, ft0 # -b - sqrt(delta)
		fdiv.s fs3, fs3, ft1 # fs3 = (-b + sqrt(delta))/2a

		# raiz x2
		fneg.s fs4, fs1  # fs3 = -b
		fadd.s fs4, fs4, ft0 # fs3 = -b + sqrt(delta)
		fdiv.s fs4, fs4, ft1 # fs3 = (-b + sqrt(delta))/2a



		li a0, 1
		j bhaskara_end

	bhaskara_complexas:
		# todo: calcular raízes complexas
	
		li a0, 2
		j bhaskara_end

	# todo: descobrir em que casos ocorre o erro
	bhaskara_erro:
		li a0, 0
		j bhaskara_end

	bhaskara_end:
		fmv.s ft0, fs3
		fmv.s ft1, fs4

		lw ra, 0(sp)
		flw fs0, 4(sp)
		flw fs1, 8(sp)
		flw fs2, 12(sp)
		flw fs3, 16(sp)
		flw fs4, 20(sp)
		addi sp, sp, 20
		
		fsw ft0, 0(sp)
		fsw ft1, 4(sp)

		ret

	# fa0 = a, fa1 = b, fa2 = c
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
	
