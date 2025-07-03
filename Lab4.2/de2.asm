addi t0, t0, 14 # E
addi t1, t1, 1  # 1
addi t2, t2, 15 # F

nop
nop
nop
nop
add t0, t0, t1 # F

nop
nop
nop
nop
sub t0, t0, t1 # E

nop
nop
nop
nop
slt t0, t0, t2 # 1

nop
nop
nop
nop
or  t0, t0, t0 # 1

nop
nop
nop
nop
and t0, t0, t1 # 1
