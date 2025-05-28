main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        lui     a5,%hi(.LC0)
        flw     fa5,%lo(.LC0)(a5)
        fsw     fa5,-20(s0)
        lui     a5,%hi(.LC1)
        flw     fa5,%lo(.LC1)(a5)
        fsw     fa5,-24(s0)
        flw     fa4,-20(s0)
        flw     fa5,-24(s0)
        fmul.s  fa5,fa4,fa5
        fcvt.w.s a5,fa5,rtz
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
.LC0:
        .word   1069547520
.LC1:
        .word   1075838976