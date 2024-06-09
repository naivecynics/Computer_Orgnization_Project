
read:
	ecall
	li t1, 0
	beq a0, t1, lui_case
	addi t1, t1, 1
	beq a0, t1, auipc_case
	beq zero, zero, read
lui_case:
	lui x29, 0xfffff
	addi x29, x29, 0x123
	mv x31, x29
	beq zero, zero, read
auipc_case:
	auipc x28, 0x12745
	addi x28, x28, 0x38
	mv x31, x28
	beq zero, zero, read
		