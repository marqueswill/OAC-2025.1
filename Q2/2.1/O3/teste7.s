.LC0:
        .string "Digite um numero:"
.LC1:
        .string "%d"
.LC2:
        .string "O resultado eh %f\n"
main:
        lui     a0,%hi(.LC0)
        addi    sp,sp,-48
        addi    a0,a0,%lo(.LC0)
        sw      ra,44(sp)
        call    printf
        lui     a0,%hi(.LC1)
        addi    a1,sp,28
        addi    a0,a0,%lo(.LC1)
        call    __isoc99_scanf
        lw      a5,28(sp)
        andi    a4,a5,1
        bne     a4,zero,.L2
        li      a4,3
        mul     a5,a5,a4
.L3:
        fcvt.s.w        fa5,a5
        lui     a0,%hi(.LC2)
        addi    a0,a0,%lo(.LC2)
        fcvt.d.s        fa5,fa5
        fsd     fa5,8(sp)
        lw      a2,8(sp)
        lw      a3,12(sp)
        call    printf
        lw      ra,44(sp)
        li      a0,0
        addi    sp,sp,48
        jr      ra
.L2:
        li      a4,7
        mul     a5,a5,a4
        j       .L3