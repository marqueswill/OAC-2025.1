clear1:
        ble     a1,zero,.L1
        slli    a2,a1,2
        li      a1,0
        tail    memset
.L1:
        ret
clear2:
        slli    a2,a1,2
        add     a5,a0,a2
        bleu    a5,a0,.L4
        li      a1,0
        tail    memset
.L4:
        ret