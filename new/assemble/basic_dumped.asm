.text
begin:
    mv a7,s2
    li t0,0
    li t1,1
    li t2,2
    li t3,3
    li t4,4
    li t5,5
    li t6,6
    li s7,7
    beq a7,t0,test000
    beq a7,t1,test001
    beq a7,t2,test010
    beq a7,t3,test011
    beq a7,t4,test100
    beq a7,t5,test101
    beq a7,t6,test110
    beq a7,s7,test111
    beq x0,x0,stall
    

test000:
    #read a
    li a7, 5
    ecall
    #move a ti register a1
    mv a1, a0
    #read b
    li a7, 5
    ecall
    #move b to register a2
    mv a2, a0
    #a1,a2 connect to led
    j begin

test001:
    #read a
    li a7, 5
    ecall
    #move a ti register a1
    mv a3, a0
    j begin 

test010:
    #read b
    li a7, 6
    ecall
    #move b to register a2
    mv a4, a0
    j begin

test011:
    beq a3, a4, light
    j notlight

test100:
    blt a3, a4, light
    j notlight

test101:
    bge a3, a4, light
    j notlight

test110:
    bltu a3, a4, light
    j notlight

test111:
    bgeu a3, a4, light
    j notlight

light:
    li a5, 1
    j stall

notlight:
    li a5, 0
    j stall

#a6 store previous count

stall:
    #read count

    bne a6, a5, begin
    mv a6, a5
    j stall
    
