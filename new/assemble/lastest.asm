case6:
     li a3, 1
     
     #ecall
     #mv a3,a0
     
     li sp,64
     li a1, 0
     li a2, 1
     li x31, 0 #´ð°¸
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
	add a0,x0,x31
	#li a7,1
	#mv a0,x31
	#ecall
