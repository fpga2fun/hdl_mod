#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <malloc.h>
#include "swap.h"
#include "selectSort.h"

int main() 
{ 
    int length = 20000; 
    long runtime; 
    int *pData = (int *)malloc(sizeof(int) * length); 

    if (pData == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    for (int i = 0; i < length; i++) {
        pData[i] = rand(); // rand() 生成随机数
    }

    runtime = clock(); 
    selectSort(pData, length / 2); 
    runtime = clock() - runtime; 
    printf("%lf\n", (double)runtime / CLOCKS_PER_SEC); 

    runtime = clock(); 
    selectSort(pData, length); 
    runtime = clock() - runtime; 
    printf("%lf\n", (double)runtime / CLOCKS_PER_SEC); 

    free(pData); 
    return 0;
}