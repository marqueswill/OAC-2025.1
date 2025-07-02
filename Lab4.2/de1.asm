addi t0, t0, 14 # E
addi t1, t1, 1  # 1
addi t2, t2, 15 # F

add t0, t0, t1 # F
sub t0, t0, t1 # E
slt t0, t0, t2 # 1
or  t0, t0, t0 # 1
and t0, t0, t1 # 1
