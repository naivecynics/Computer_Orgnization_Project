.text


/* 
3‘b000
输入测试数a, 输入测试数b，在输出设备(led)上展示8bit的a和b的值
3‘b001
输入测试数a ，以lb的方式放入某个寄存器，将该32位的寄存器的值以十六进制的方式展示在输出设备上(数码管或者VGA)，并将该 数保存到memory中 (在3’b011-3’b111用例中，将通过lw 指令从该memory单元中读取a的值进行比较)
3‘b010
输入测试数b，以 lbu 的方式存入某个寄存器，将该32位寄存器的值以十六进制的方式展示在输出设备上(数码管或者VGA)，并将该 数保存到memory中(在3’b011-3’b111用例中，将通过lw 指令从该memory单元中读取a的值进行比较)
3‘b011
用 beq 比较 测试数 a 和 测试数 b(来自于用例1和用例2)，如果关系成立，点亮led，关系不成立，led熄灭
3‘b100
用 blt 比较 测试数 a 和 测试数 b(来自于用例1和用例2)，如果关系成立，点亮led，关系不成立，led熄灭
3‘b101
用 bge 比较 测试数 a 和 测试数 b(来自于用例1和用例2)，如果关系成立，点亮led，关系不成立，led熄灭
3‘b110
用 bltu 比较 测试数 a 和 测试数 b(来自于用例1和用例2)，如果关系成立，点亮led，关系不成立，led熄灭
3‘b111
用 bgeu 比较 测试数 a 和 测试数 b(来自于用例1和用例2)，如果关系成立，点亮led，关系不成立，led熄灭
*/

begin:
    lw a7,
    li t0,0
    li t1,1
    li t2,2
    li t3,3
    li t4,4
    li t5,5
    li t6,6
    li t7,7
    beq a7,t0,test000
    beq a7,t1,test001
    beq a7,t2,test010
    beq a7,t3,test011
    beq a7,t4,test100
    beq a7,t5,test101
    beq a7,t6,test110
    beq a7,t7,test111
    j stall
    

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
    
