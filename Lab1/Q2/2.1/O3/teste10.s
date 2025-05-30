plot:
        slli    a5,a1,2
        add     a1,a5,a1
        slli    a1,a1,6
        add     a1,a1,a0
        li      a5,-16777216
        add     a5,a5,a1
        sb      a2,0(a5)
        ret
tecla:
        li      a5,-14680064
        lw      a5,0(a5)
        li      a0,199
        beq     a5,zero,.L3
        li      a5,-14680064
        lw      a0,4(a5)
.L3:
        ret
main:
        addi    sp,sp,-16
        sw      s0,8(sp)
        li      s0,-14680064
        lw      a5,0(s0)
        sw      ra,12(sp)
        beq     a5,zero,.L9
        sw      s1,4(sp)
        li      s1,199
.L8:
        lw      a1,4(s0)
        andi    a5,a1,0xff
        bne     a5,s1,.L10
.L11:
        j       .L11
.L10:
        li      a2,77824
        andi    a1,a1,0xff
        addi    a2,a2,-1024
        li      a0,-16777216
        call    memset
        lw      a5,0(s0)
        bne     a5,zero,.L8
        lw      s1,4(sp)
.L9:
.L14:
        j       .L14