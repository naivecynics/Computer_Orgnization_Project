#����branch����ָ��
#beq, bne, blt, bge, bltu, bgeu
#beq ���ʱ��ת
#bne �����ʱ��ת
#blt С��ʱ��ת
#bge ���ڵ���ʱ��ת
#bltu С��ʱ��ת���޷��ţ�
#bgeu ���ڵ���ʱ��ת���޷��ţ�

#����beq
main:
    li x1, 10
    li x2, 10
    beq x1, x2, end
    li x3, 1
    j end

end:
    li x4, 0
