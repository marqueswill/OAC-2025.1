addi t0, t0, 14 # E
addi t1, t1, 1  # 1
addi t2, t2, 15 # F

sw t0, 0(sp)
addi t0, zero, 10

jal t3, skip

continue1:
beq t2, t0, continue2

continue2:
add t0, t0, t1 # F
sub t0, t0, t1 # E
slt t0, t0, t2 # 1
or  t0, t0, t0 # 1
and t0, t0, t1 # 1

j end

skip:
lw t0, 0(sp) # E
jr t3

end:
