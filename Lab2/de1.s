.data
.word 1

.text
	#li gp,0x10010000
	lw t0,0(gp)
LOOP: 	add t0,t0,t0
	j LOOP
