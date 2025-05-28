.LC0:
        .string "Numero: %d\n"
main:
        lui     a0,%hi(.LC0)
        addi    sp,sp,-16
        addi    a0,a0,%lo(.LC0)
        li      a1,1234
        sw      ra,12(sp)
        call    printf
        lw      ra,12(sp)
        li      a0,1236
        addi    sp,sp,16
        jr      ra