#register x31 connected to the digit tube
#register x30 connected to the led light
# input stored in a0
#t5 t6不要用

main:
    lui x29, 0xffff0
    #li a0, 6
    ecall
    li t0, 0
    beq t0, a0, case0
    li t0, 1
    beq t0, a0, case1
    li t0, 2
    beq t0, a0, case2
    li t0, 3
    beq t0, a0, case3
    li t0, 4
    beq t0, a0, case4
    li t0, 5
    beq t0, a0, case5
    li t0, 6
    beq t0, a0, case6
    j end
    

#输入一个 8bit 的数，计算并输出其前导零的个数
case0:
    #li a0,19
    ecall
    li t1,7
    li t3,7
    li x31,0

	case0loop:
    li t2,1
    srl a1,a0,t1
    bne a1,x0,case0loopend
    addi t1,t1,-1
    addi x31,x31,1
    beq t3,x31,case0loopend
    j case0loop

	case0loopend:
    j end

case1:
    #提取符号位 1bit
    #li a0,0xca50
    ecall
    li a3, 1
    slli a3,a3,15
    and t1,a0,a3
    #提取指数位 5bit
    li a3, 31
    slli a3,a3,10
    and t2,a0,a3
    srli t2,t2,10
    #提取尾数位 10bit
    andi t3,a0,0x03ff 
    #计算正确的指数值
    addi t2,t2,-15
    #预处理一些数
    li t4, 512
    #指数大于等于0
    li x31, 1
    bge t2,x0,case1_loop1
    #指数小于0
    li x31 ,0
    j case1_end

    case1_loop1:
        addi t2,t2,-1
        #循环条件
        blt t2,x0,case1_end
        #取出尾数当前
        and a1,t3,t4
        srli t4,t4,1
        slt a2,x0,a1
        slli x31,x31,1
        add x31,x31,a2
        j case1_loop1
     
     case1_end:
     blt x0,t1 case1_neg_end
     addi x31,x31,1
     j end
     
     case1_neg_end:
     xori x31,x31,-1
     addi x31,x31,1
     j end

case2:
    #li a0,0xca50
    ecall
    #提取符号位 1bit
    li a3,1
    slli a3,a3,15
    and t1,a0,a3
    #提取指数位 5bit
    li a3, 31
    slli a3,a3,10
    and t2,a0,a3
    srli t2,t2,10
    #提取尾数位 10bit
    andi t3,a0,0x03ff 
    #计算正确的指数值
    addi t2,t2,-15
    #预处理一些数
    li t4, 512
    #指数大于等于0
    li x31, 1
    bge t2,x0,case2_loop1
    #指数小于0
    li x31 ,0
    j case2_end

    case2_loop1:
        addi t2,t2,-1
        #循环条件
        blt t2,x0,case2_end
        #取出尾数当前
        and a1,t3,t4
        srli t4,t4,1
        slt a2,x0,a1
        slli x31,x31,1
        add x31,x31,a2
        j case2_loop1
     
     case2_end:
     blt x0,t1 case2_neg_end
     j end
     
     case2_neg_end:
     addi x31,x31,1
     xori x31,x31,-1
     addi x31,x31,1
     j end
     
case3:
    #li a0,0x4a50
    ecall
    #提取符号位 1bit
    li a3,1
    slli a3,a3,15
    and t1,a0,a3
    #提取指数位 5bit
    li a3, 31
    slli a3,a3,10
    and t2,a0,a3
    srli t2,t2,10
    #提取尾数位 10bit
    andi t3,a0,0x03ff 
    #计算正确的指数值
    addi t2,t2,-15
    #预处理一些数
    li t4, 512
    #算出小数第一位
    li a4, 9
    sub a4,a4,t2
    #指数大于等于0
    li x31, 1
    bge t2,x0,case3_loop1
    #指数小于0
    li x31 ,0
    j case3_end

    case3_loop1:
        addi t2,t2,-1
        #循环条件
        blt t2,x0,case3_end
        #取出尾数当前
        and a1,t3,t4
        srli t4,t4,1
        slt a2,x0,a1
        slli x31,x31,1
        add x31,x31,a2
        j case3_loop1
     
     case3_end:
     blt x0,t1 case3_neg_end
     addi a5,x0,1
     sll a5,a5,a4
     and a5,a5,a0
     slt a5,x0,a5
     add x31,x31,a5
     j end
     
     case3_neg_end:
     addi x31,x31,1
     xori x31,x31,-1
     addi x31,x31,1
     addi a5,x0,1
     sll a5,a5,a4
     and a5,a5,a0
     slt a5,x0,a5
     add x31,x31,a5
     j end

case4:
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
	j end
	
case5:
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
    j end

case6:
     #li a3, 11
     ecall
     mv a3,a0
     
     li a1, 0
     li a2, 1
     li x31, 0 #答案
     jal fib
     j end
     
     fib:
     	addi sp,sp,-8
     	sw ra, 4(sp)
     	sw a2, 0(sp)
     	slt t0,a3,a2
     	beq t0,zero, L1
     	addi sp,sp,8
     	jr ra
     
     L1:
     	mv t1,a1
     	mv a1,a2
     	add a2,a2,t1
     	jal fib
     	addi x31,x31,1
	lw ra,4(sp)
	addi sp,sp,8
	jr ra
	
end:
    #li a7,1
    #mv a0,x31
    j main
