.data
input_vector: .space 12
return_buffer: .space 128
input_buffer: .space 128

error_msg: .asciz "Erro! Não é equação do segundo grau!"
break_line: .asciz "\n"

root_1: .asciz "R(1) = "
root_2: .asciz "R(2) = "
sep_plus: .asciz " + "
sep_minus: .asciz " - "
complex_end: .asciz  " i"


.text
.globl main

main:
	jal read_input

	la t0, input_vector
	flw fa0, 0(t0)
	flw fa1, 4(t0)
	flw fa2, 8(t0)
	addi sp, sp, 12 # restaura a pilha

	jal bhaskara
	jal show_roots

	li a7, 10
	ecall

read_input:
	addi sp, sp, -12 # aloca espaço na pilha

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
	addi sp, sp, -24
	sw  ra,  0(sp)
	fsw fs0, 4(sp)  # a
	fsw fs1, 8(sp)  # b
	fsw fs2, 12(sp) # c
	fsw fs3, 16(sp) # x1 / alfa
	fsw fs4, 20(sp) # x2 / beta
	
	fmv.s fs0, fa0
	fmv.s fs1, fa1
	fmv.s fs2, fa2

	jal bhaskara_delta # fa0 = delta

	fmv.w.x ft0, zero
	flt.s t0, fa0, ft0
	bnez t0, bhaskara_complexas # delta < 0

	bhaskara_reais:
		fsqrt.s ft0, fa0      # ft0 = sqrt(delta)
		fadd.s  ft1, fs0, fs0 # ft1 = 2a

		# raiz x1
		fneg.s fs3, fs1      # fs3 = -b
		fsub.s fs3, fs3, ft0 # fs3 = -b - sqrt(delta)
		fdiv.s fs3, fs3, ft1 # fs3 = (-b + sqrt(delta))/2a

		# raiz x2
		fneg.s fs4, fs1      # fs4 = -b
		fadd.s fs4, fs4, ft0 # fs4 = -b + sqrt(delta)
		fdiv.s fs4, fs4, ft1 # fs4 = (-b + sqrt(delta))/2a

		li a0, 1
		j bhaskara_end

	bhaskara_complexas:
		fneg.s  ft0, fa0      # -delta
		fsqrt.s ft0, ft0      # ft0 = sqrt(-delta)
		fadd.s  ft1, fs0, fs0 # ft1 = 2a

		# alfa
		fneg.s fs3, fs1      # fs3 = -b
		fdiv.s fs3, fs3, ft1 # fs3 = -b / 2a

		# beta
		fdiv.s fs4, ft0, ft1 # fs3 = sqrt(-delta)/2a
	
		li a0, 2
		j bhaskara_end

	# todo: descobrir em que casos ocorre o erro
	bhaskara_erro:
		li a0, 0
		j bhaskara_end

	bhaskara_end:
		fmv.s ft0, fs3 # fiz isso só pra não confundir no ajuste da pilha
		fmv.s ft1, fs4

		lw  ra,  0(sp)
		flw fs0, 4(sp)
		flw fs1, 8(sp)
		flw fs2, 12(sp)
		flw fs3, 16(sp)
		flw fs4, 20(sp)

		addi sp, sp, 24
		
		addi sp, sp, -8 
		fsw ft0, 0(sp)
		fsw ft1, 4(sp)

		ret

	# fs0 = a, fs1 = b, fs2 = c
	bhaskara_delta:
		fmul.s ft0, fs1, fs1 # b^2
		
		li t1, 4
		fcvt.s.w ft1, t1     # 4
		fmul.s ft1, ft1, fs0 # 4a
		fmul.s ft1, ft1, fs2 # 4ac
		fsub.s fa0, ft0, ft1 # b^2 - 4ac 
		
		ret


show_roots:
	flw ft0, 0(sp)
	flw ft1, 4(sp)
	addi sp, sp, 8
	
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t0, 1
	beq a0, t0, show_real_roots

	li t0, 2
	beq a0, t0, show_complex_roots

	show_error_message:
		la a0, error_msg
		li a7, 4
		ecall
		j end_show_roots

	show_real_roots:
		# todo: show float roots too
		fcvt.w.s a0, ft0
		la a1, input_buffer
		jal int_to_string

		la a0, root_1
		la a1, input_buffer
		jal concat_strings

		la a0, return_buffer
		li a7, 4
		ecall

		li a0, '\n'
		li a7, 11
		ecall

		fcvt.w.s a0, ft1
		la a1, input_buffer
		jal int_to_string

		la a0, root_2
		la a1, input_buffer
		jal concat_strings

		la a0, return_buffer
		li a7, 4
		ecall

		j end_show_roots

	show_complex_roots:
		j end_show_roots

	end_show_roots:
		lw ra, 0(sp)
		addi sp, sp, 4
		ret

# concat_strings(a0 = address of str1, a1 = address of str2)
concat_strings:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	la t2, return_buffer

	find_end:
		lb  t0, 0(a0)
		beq t0, zero, append
	
		sb   t0, 0(t2)
		addi t2, t2, 1

		addi a0, a0, 1     
		j find_end
	

	append:
		lb t1, 0(a1)       
		sb t1, 0(t2)        
		beq t1, zero, end_concat_string   
		addi t2, t2, 1       
		addi a1, a1, 1       
		j append
	
	end_concat_string:
		lw   ra, 0(sp)
		addi sp, sp, 4	
		ret

# copia a string em a0 para a1
copy_string:
	addi sp, sp, -4
	sw ra, 0(sp)

	copy_loop:
		lb  t0, 0(a0)
		beq t0, zero, end_copy
	
		sb   t0, 0(a1)
		addi a1, a1, 1
		addi a0, a0, 1     
		j copy_loop

	end_copy:
		sb t0, 0(t2) # fecha a string
	
		lw ra, 0(sp)
		addi sp, sp, 4
		ret

# int_to_string(a0 = integer, a1 = address of buffer)
int_to_string:
	addi sp, sp, -4
	sw ra, 0(sp)

	mv t0, a0           # t0 = number
	mv t1, a1           # t1 = buffer pointer (write position)
    
	beqz t0, write_zero # if number is 0, handle specially

	convert_loop:
		li t2, 10
		rem t3, t0, t2      # t3 = digit = t0 % 10
		addi t3, t3, 48     # convert digit to ASCII
		sb t3, 0(t1)        # store in buffer
		addi t1, t1, 1      # advance buffer
		div t0, t0, t2      # t0 = t0 / 10
		bnez t0, convert_loop
	
		j reverse_string
	
	write_zero:
		li t3, '0'
		sb t3, 0(t1)
		addi t1, t1, 1
	
	reverse_string:
		sb zero, 0(t1)       # null terminator
	
		#Reverse the string in buffer
		mv   t2, a1            # t2 = start
		addi t3, t1, -1      # t3 = end (last digit before null)
	
	reverse_loop:
		blt t3, t2, end_int_to_string     # if end < start, we're done
	    	lbu t4, 0(t2)
		lbu t5, 0(t3)
		sb t5, 0(t2)
		sb t4, 0(t3)
		addi t2, t2, 1
		addi t3, t3, -1
		j reverse_loop
	
	end_int_to_string:
		lw ra, 0(sp)
		addi sp, sp 4
		ret
