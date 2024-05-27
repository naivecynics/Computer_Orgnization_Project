.text
    lui x29, 0xffff0
test_case4:
    li t1, 0
    li t2, 0
    li a1, 0
    li a2, 0
    ecall
    sw a0, 0x040(x29)
    lbu t1, 0x040(x29)
    ecall
    sw a0, 0x044(x29)
    lbu t2, 0x044(x29)
    add a1, t1, t2
    sw a1, 0x048(x29)
    lbu a2, 0x048(x29)
    beq a1, a2, add0
    addi a2, a2, 1
add0:
    addi a2, a2, 0
    xori a2, a2, -1
    sw a2, 0x04C(x29)
    lbu x31, 0x04C(x29)
    
test_case5:
    li a4, 0
    li a5, 0
    ecall
    add a4, a0, zero
    ecall
    add a5, a0, zero
    li t1, 16
    bge a5, t1, check_12bit
    slli a4, a4, 8
    add a4, a5, a4
    beq zero, zero, print
check_12bit:
    slli a4, a4, 4
print:
    mv x31,a4    
    
    
    
    
    
    
    
