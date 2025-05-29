.LC0:
        .string "Digite um numero:"
.LC1:
        .string "%d"
.LC2:
        .string "Fora dos Limites"
.LC3:
        .string "Dentro dos Limites"
main:
        lui     a0,%hi(.LC0)
        addi    sp,sp,-32
        addi    a0,a0,%lo(.LC0)
        sw      ra,28(sp)
        call    printf
        lui     a0,%hi(.LC1)
        addi    a1,sp,15
        addi    a0,a0,%lo(.LC1)
        call    __isoc99_scanf
        lbu     a4,15(sp)
        li      a5,99
        bleu    a4,a5,.L2
        lui     a0,%hi(.LC2)
        addi    a0,a0,%lo(.LC2)
        call    puts
.L3:
        lw      ra,28(sp)
        li      a0,0
        addi    sp,sp,32
        jr      ra
.L2:
        lui     a0,%hi(.LC3)
        addi    a0,a0,%lo(.LC3)
        call    puts
        j       .L3