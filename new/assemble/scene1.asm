.text
	lui x29, 0xfffff
	addi x29, x29, 0x0000
read:
	#x31: seg    x30: led
	ecall
	mv s11, a0 #s11 store test case
	
	li a2, 0
	addi s2, zero, 0
	beq s11, s2, test_case0
	addi s2, s2, 1
	beq s11, s2, test_case1
	addi s2, s2, 1
	beq s11, s2, test_case2
	addi s2, s2, 1
	beq s11, s2, test_case3
	addi s2, s2, 1
	beq s11, s2, test_case4
	addi s2, s2, 1
	beq s11, s2, test_case5
	addi s2, s2, 1
	beq s11, s2, test_case6
	addi s2, s2, 1
	beq s11, s2, test_case7
	beq zero, zero, read
	
	#test_case
test_case0:
	ecall
	mv x30, a0
	ecall
	mv x30, a0
	beq zero, zero, read
test_case1:
	ecall
	sw a0, 0x000(x29)
	lb t1, 0x000(x29)
	sw t1, 0x000(x29)
	mv x31, t1
	beq zero, zero, read
test_case2:
	ecall
	sw a0, 0x004(x29)
	lbu t2, 0x004(x29)
	sw t2, 0x004(x29)
	mv x31, t2
	beq zero, zero, read
test_case3:
	lw t1, 0x000(x29)
	lw t2, 0x004(x29)
	beq t1, t2, light
	li x30, 0
	beq zero, zero, read
test_case4:
	lw t1, 0x000(x29)
	lw t2, 0x004(x29)
	blt t1, t2, light
	li x30, 0
	beq zero, zero, read
test_case5:
	lw t1, 0x000(x29)
	lw t2, 0x004(x29)
	bge t1, t2, light
	li x30, 0
	beq zero, zero, read
test_case6:
	lw t1, 0x000(x29)
	lw t2, 0x004(x29)
	bltu t1, t2, light
	li x30, 0
	beq zero, zero, read
test_case7:
	lw t1, 0x000(x29)
	lw t2, 0x004(x29)
	bgeu t1, t2, light
	li x30, 0
	beq zero, zero, read
light:
	li x30, 1 
	beq zero, zero, read
	
	
	
