#include<stdio.h> 

int main(int argc, char *argv[]) 
{ 
    unsigned int iNum1, iNum2, temp; 

    // 读取两个十六进制数
    scanf("%x%x", &iNum1, &iNum2); 

    // 打印两个数的地址
    printf("%p, %p\n", &iNum1, &iNum2); 

    // 打印两个数的值
    printf("%x, %x\n", iNum1, iNum2); 

    // 交换两个数的值
    temp = iNum1; 
    iNum1 = iNum2; 
    iNum2 = temp; 

    // 再次打印两个数的地址
    printf("%p, %p\n", &iNum1, &iNum2); 

    // 再次打印两个数的值
    printf("%x, %x\n", iNum1, iNum2); 

    return 0; 
}