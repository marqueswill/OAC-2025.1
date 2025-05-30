soma_recursiva:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      a0,-20(s0)
        lw      a5,-20(s0)
        bgt     a5,zero,.L2
        li      a5,0
        j       .L3
.L2:
        lw      a5,-20(s0)
        addi    a5,a5,-1
        mv      a0,a5
        call    soma_recursiva
        mv      a4,a0
        lw      a5,-20(s0)
        add     a5,a4,a5
.L3:
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra