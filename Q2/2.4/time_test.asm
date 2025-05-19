main:
csrr s1,3074
csrr s0,3073
call ff1
csrr t0,3073    
csrr t1,3074   
sub s0,t0,s0    
sub s1,t1,s1   

li a7, 1
mv a0, s0
ecall
li a0, '\n'
li a7, 11
ecall
li a7, 1
mv a0, s1
ecall
li a0, '\n'
li a7, 11
ecall
ecall


csrr s1,3074
csrr s0,3073
call ff2
csrr t0,3073    
csrr t1,3074   
sub s0,t0,s0    
sub s1,t1,s1   

li a7, 1
mv a0, s0
ecall
li a0, '\n'
li a7, 11
ecall
li a7, 1
mv a0, s1
ecall
li a0, '\n'
li a7, 11
ecall
ecall


csrr s1,3074
csrr s0,3073
call ff3
csrr t0,3073    
csrr t1,3074   
sub s0,t0,s0    
sub s1,t1,s1   

li a7, 1
mv a0, s0
ecall
li a0, '\n'
li a7, 11
ecall
li a7, 1
mv a0, s1
ecall
li a0, '\n'
li a7, 11
ecall
ecall

csrr s1,3074
csrr s0,3073
call ff4
csrr t0,3073    
csrr t1,3074   
sub s0,t0,s0    
sub s1,t1,s1   

li a7, 1
mv a0, s0
ecall
li a0, '\n'
li a7, 11
ecall
li a7, 1
mv a0, s1
ecall
li a0, '\n'
li a7, 11
ecall
ecall

csrr s1,3074
csrr s0,3073
call ff5
csrr t0,3073    
csrr t1,3074   
sub s0,t0,s0    
sub s1,t1,s1   

li a7, 1
mv a0, s0
ecall
li a0, '\n'
li a7, 11
ecall
li a7, 1
mv a0, s1
ecall
li a0, '\n'
li a7, 11
ecall
ecall

csrr s1,3074
csrr s0,3073
call ff6
csrr t0,3073    
csrr t1,3074   
sub s0,t0,s0    
sub s1,t1,s1   

li a7, 1
mv a0, s0
ecall
li a0, '\n'
li a7, 11
ecall
li a7, 1
mv a0, s1
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
        lui     a5,%hi(.LC0)
        fcvt.d.w        fa5,a0
        fld     fa4,%lo(.LC0)(a5)
        fmul.d  fa5,fa5,fa4
        fcvt.w.d a0,fa5,rtz
        ret
        
.data
.LC0:
        .word   0
        .word   1074790400