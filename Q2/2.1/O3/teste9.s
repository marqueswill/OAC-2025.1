proc:
        add     a0,a0,a1
        lbu     a5,1(a0)
        lbu     a4,0(a0)
        mul     a5,a5,a4
        fcvt.s.w        fa0,a5
        ret
.LC1:
        .string "Digite um numero:"
.LC2:
        .string "%d"
.LC3:
        .string "Resultado:%f\n"
.LC0:
        .string "\001\002\003\004\005\006\007\b\t\n\013\f\r\016\017\020"
main:
        lui     a5,%hi(.LC0)
        addi    a5,a5,%lo(.LC0)
        lw      a2,0(a5)
        lw      a3,4(a5)
        lw      a4,8(a5)
        lw      a5,12(a5)
        lui     a0,%hi(.LC1)
        addi    sp,sp,-64
        addi    a0,a0,%lo(.LC1)
        sw      ra,60(sp)
        sw      a2,32(sp)
        sw      a3,36(sp)
        sw      a4,40(sp)
        sw      a5,44(sp)
        call    printf
        lui     a0,%hi(.LC2)
        addi    a1,sp,31
        addi    a0,a0,%lo(.LC2)
        call    __isoc99_scanf
        lbu     a5,31(sp)
        lui     a0,%hi(.LC3)
        addi    a0,a0,%lo(.LC3)
        add     a5,a5,sp
        lbu     a4,33(a5)
        lbu     a5,32(a5)
        mul     a5,a4,a5
        fcvt.d.w        fa5,a5
        fsd     fa5,8(sp)
        lw      a2,8(sp)
        lw      a3,12(sp)
        call    printf
        lw      ra,60(sp)
        li      a0,0
        addi    sp,sp,64
        jr      ra