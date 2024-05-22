#测试branch类型指令
#beq, bne, blt, bge, bltu, bgeu
#beq 相等时跳转
#bne 不相等时跳转
#blt 小于时跳转
#bge 大于等于时跳转
#bltu 小于时跳转（无符号）
#bgeu 大于等于时跳转（无符号）

#测试beq
main:
    li x1, 10
    li x2, 10
    beq x1, x2, end
    li x3, 1
    j end

end:
    li x4, 0
