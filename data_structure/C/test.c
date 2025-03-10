#include <stdio.h> 
int main(int argc, char *argv[]) 
{ 
    int iNum = 0x64; 
    int *ptr = &iNum; 
    int **pPtr = &ptr; 

    printf("&iNum = 0x%p, iNum = 0x%x\n", (void*)&iNum, iNum); 
    printf("&ptr = 0x%p, ptr = 0x%p, *ptr = 0x%x\n", (void*)&ptr, (void*)ptr, *ptr); 
    printf("&pPtr = 0x%p, pPtr = 0x%p, *pPtr = 0x%p, **pPtr = 0x%x\n", (void*)&pPtr, (void*)pPtr, (void*)*pPtr, **pPtr); 
    return 0; 
}