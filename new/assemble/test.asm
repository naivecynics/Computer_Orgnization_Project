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
    li x1, 9
    li x2, 10
    j end
    li x1,11111
end:
    li x4, 0
