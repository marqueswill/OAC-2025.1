show:
         mv     t0,a0 
         mv     t1,a1 
         mv     t2,zero 
loop1:  beq     t2,t1,fim1 
        li      a7,1 
        lw      a0,0(t0) 
        ecall 
        li      a7,11 
        li      a0,9 
        ecall 
        addi    t0,t0,4 
        addi    t2,t2,1 
        j       loop1 
fim1:   li      a7,11 
        li      a0,10 
        ecall 

        ret
swap:
        slli    a1,a1,2
        add     a5,a0,a1
        addi    a1,a1,4
        add     a0,a0,a1
        lw      a3,0(a0)
        lw      a4,0(a5)
        sw      a3,0(a5)
        sw      a4,0(a0)
        ret
sort:
        addi    sp,sp,-32
        sw      s1,20(sp)
        sw      s2,16(sp)
        sw      s4,8(sp)
        sw      s5,4(sp)
        sw      ra,28(sp)
        sw      s0,24(sp)
        sw      s3,12(sp)
        mv      s2,a0
        mv      s4,a1
        li      s1,0
        li      s5,-1
.L4:
        blt     s1,s4,.L9
        lw      ra,28(sp)
        lw      s0,24(sp)
        lw      s1,20(sp)
        lw      s2,16(sp)
        lw      s3,12(sp)
        lw      s4,8(sp)
        lw      s5,4(sp)
        addi    sp,sp,32
        jr      ra
.L9:
        slli    s0,s1,2
        addi    s3,s1,-1
        add     s0,s2,s0
.L5:
        bne     s3,s5,.L6
.L8:
        addi    s1,s1,1
        j       .L4
.L6:
        lw      a4,-4(s0)
        addi    s0,s0,-4
        lw      a5,4(s0)
        ble     a4,a5,.L8
        mv      a1,s3
        mv      a0,s2
        call    swap
        addi    s3,s3,-1
        j       .L5
main:
        addi    sp,sp,-16
        sw      s0,8(sp)
        lui     s0,%hi(.LANCHOR0)
        addi    a0,s0,%lo(.LANCHOR0)
        li      a1,30
        sw      ra,12(sp)
        call    show
        addi    a0,s0,%lo(.LANCHOR0)
        li      a1,30
        call    sort
        addi    a0,s0,%lo(.LANCHOR0)
        li      a1,30
        call    show
        lw      ra,12(sp)
        lw      s0,8(sp)
        li      a0,0
        addi    sp,sp,16
        jr      ra
        .set    .LANCHOR0,. + 0
v:
        .word   9
        .word   2
        .word   5
        .word   1
        .word   8
        .word   2
        .word   4
        .word   3
        .word   6
        .word   7
        .word   10
        .word   2
        .word   32
        .word   54
        .word   2
        .word   12
        .word   6
        .word   3
        .word   1
        .word   78
        .word   54
        .word   23
        .word   1
        .word   54
        .word   2
        .word   65
        .word   3
        .word   6
        .word   55
        .word   31