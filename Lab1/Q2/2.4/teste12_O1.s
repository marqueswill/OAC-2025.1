f1:
        slli    a0,a0,2
        ret
f2:
        slli    a0,a0,2
        ret
f3:
        slli    a0,a0,2
        ret
f4:
        slli    a0,a0,2
        ret
f5:
        slli    a0,a0,2
        ret
f6:
        fcvt.d.w        fa5,a0
        lui     a5,%hi(.LC0)
        fld     fa4,%lo(.LC0)(a5)
        fmul.d  fa5,fa5,fa4
        fcvt.w.d a0,fa5,rtz
        ret
.LC0:
        .word   0
        .word   1074790400