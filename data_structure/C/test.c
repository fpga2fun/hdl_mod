#include<stdio.h> 

int main(int argc, char *argv[]) 
{ 
    unsigned int iNum1, iNum2, temp; 

    // ��ȡ����ʮ��������
    scanf("%x%x", &iNum1, &iNum2); 

    // ��ӡ�������ĵ�ַ
    printf("%p, %p\n", &iNum1, &iNum2); 

    // ��ӡ��������ֵ
    printf("%x, %x\n", iNum1, iNum2); 

    // ������������ֵ
    temp = iNum1; 
    iNum1 = iNum2; 
    iNum2 = temp; 

    // �ٴδ�ӡ�������ĵ�ַ
    printf("%p, %p\n", &iNum1, &iNum2); 

    // �ٴδ�ӡ��������ֵ
    printf("%x, %x\n", iNum1, iNum2); 

    return 0; 
}