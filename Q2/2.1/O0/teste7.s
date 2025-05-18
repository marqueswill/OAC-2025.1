.LC0:
        .string "Digite um numero:"
.LC1:
        .string "%d"
.LC2:
        .string "O resultado eh %f\n"
main:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        lui     a5,%hi(.LC0)
        addi    a0,a5,%lo(.LC0)
        call    printf
        addi    a5,s0,-24
        mv      a1,a5
        lui     a5,%hi(.LC1)
        addi    a0,a5,%lo(.LC1)
        call    __isoc99_scanf
        lw      a5,-24(s0)
        andi    a5,a5,1
        bne     a5,zero,.L2
        lw      a4,-24(s0)
        mv      a5,a4
        slli    a5,a5,1
        add     a5,a5,a4
        fcvt.s.w        fa5,a5
        fsw     fa5,-20(s0)
        j       .L3
.L2:
        lw      a4,-24(s0)
        mv      a5,a4
        slli    a5,a5,3
        sub     a5,a5,a4
        fcvt.s.w        fa5,a5
        fsw     fa5,-20(s0)
.L3:
        flw     fa5,-20(s0)
        fcvt.d.s        fa5,fa5
        fsd     fa5,-40(s0)
        lw      a2,-40(s0)
        lw      a3,-36(s0)
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    printf
        li      a5,0
        mv      a0,a5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra