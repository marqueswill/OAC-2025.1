proc:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        mv      a5,a1
        sb      a5,-37(s0)
        lbu     a5,-37(s0)
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mv      a3,a5
        lbu     a5,-37(s0)
        addi    a5,a5,1
        lw      a4,-36(s0)
        add     a5,a4,a5
        lbu     a5,0(a5)
        mul     a5,a3,a5
        fcvt.s.w        fa5,a5
        fsw     fa5,-20(s0)
        flw     fa5,-20(s0)
        fmv.s   fa0,fa5
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
.LC1:
        .string "Digite um numero:"
.LC2:
        .string "%d"
.LC3:
        .string "Resultado:%f\n"
.LC0:
        .ascii  "\001\002\003\004\005\006\007\b\t\n\013\f\r\016\017\020"
main:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        addi    s0,sp,64
        lui     a5,%hi(.LC0)
        addi    a5,a5,%lo(.LC0)
        lw      a2,0(a5)
        lw      a3,4(a5)
        lw      a4,8(a5)
        lw      a5,12(a5)
        sw      a2,-36(s0)
        sw      a3,-32(s0)
        sw      a4,-28(s0)
        sw      a5,-24(s0)
        lui     a5,%hi(.LC1)
        addi    a0,a5,%lo(.LC1)
        call    printf
        addi    a5,s0,-17
        mv      a1,a5
        lui     a5,%hi(.LC2)
        addi    a0,a5,%lo(.LC2)
        call    __isoc99_scanf
        lbu     a4,-17(s0)
        addi    a5,s0,-36
        mv      a1,a4
        mv      a0,a5
        call    proc
        fmv.s   fa5,fa0
        fcvt.d.s        fa5,fa5
        fsd     fa5,-56(s0)
        lw      a2,-56(s0)
        lw      a3,-52(s0)
        lui     a5,%hi(.LC3)
        addi    a0,a5,%lo(.LC3)
        call    printf
        li      a5,0
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra