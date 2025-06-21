addi t0, t0, 14
addi t1, t1, 1

add t0, t0, t1
sub t0, t0, t1
slt t0, t1, t0
or t0, t0, t0
and t0,t0,t0

#lw, sw, beq, jal, jalr e