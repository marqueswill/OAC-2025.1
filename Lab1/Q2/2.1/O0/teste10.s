plot:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        mv      a5,a2
        sb      a5,-41(s0)
        li      a5,-16777216
        sw      a5,-20(s0)
        lw      a4,-40(s0)
        mv      a5,a4
        slli    a5,a5,2
        add     a5,a5,a4
        slli    a5,a5,6
        mv      a4,a5
        lw      a5,-36(s0)
        add     a5,a4,a5
        mv      a4,a5
        lw      a5,-20(s0)
        add     a5,a5,a4
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        lbu     a4,-41(s0)
        sb      a4,0(a5)
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra
tecla:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        li      a5,-14680064
        addi    a5,a5,4
        sw      a5,-20(s0)
        li      a5,-14680064
        sw      a5,-24(s0)
        lw      a5,-24(s0)
        lw      a5,0(a5)
        beq     a5,zero,.L3
        lw      a5,-20(s0)
        lw      a5,0(a5)
        j       .L4
.L3:
        li      a5,199
.L4:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra
main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
.L11:
        call    tecla
        mv      a5,a0
        sb      a5,-25(s0)
        lbu     a4,-25(s0)
        li      a5,199
        beq     a4,a5,.L11
        sw      zero,-24(s0)
        j       .L7
.L10:
        sw      zero,-20(s0)
        j       .L8
.L9:
        lbu     a5,-25(s0)
        mv      a2,a5
        lw      a1,-24(s0)
        lw      a0,-20(s0)
        call    plot
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L8:
        lw      a4,-20(s0)
        li      a5,319
        ble     a4,a5,.L9
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L7:
        lw      a4,-24(s0)
        li      a5,239
        ble     a4,a5,.L10
        j       .L11