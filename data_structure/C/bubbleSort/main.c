 #include<stdio.h> 
 #include<string.h> 

typedef int(*COMPARE)(const void * e1, const void *e2); 
void byte_swap(void *pData1, void *pData2, size_t stSize) 
{ 
unsigned char *pcData1 = pData1; 
unsigned char *pcData2 = pData2; 
unsigned char ucTemp;

while (stSize--){ 
 ucTemp = *pcData1; *pcData1 = *pcData2; *pcData2 = ucTemp; 
 pcData1++; pcData2++; 
 } 
} 
 
 void bubbleSort(void * base, size_t nmemb, size_t size, COMPARE compare) 
 { 
 int hasSwap=1; 
 
    for (size_t i = 1; hasSwap&&i < nmemb; i++) { 
        hasSwap = 0; 
        for (size_t j = 0; j < nmemb - 1; j++) { 
            void *pThis = ((unsigned char *)base) + size*j; 
            void *pNext = ((unsigned char *)base) + size*(j+1); 
            if (compare(pThis, pNext) > 0) { 
                hasSwap = 1; 
                byte_swap(pThis, pNext, size); 
                } 
        } 
    } 
 } 
 int compare_int(const void * e1, const void * e2) 
{
   return *(int *)e1 - *(int *)e2; 
   } 
   
int compare_int_r(const void * e1, const void * e2) 
    { 
    return *(int *)e2 - *(int *)e1 ; 
    } 
    
int compare_str(const void * e1, const void *e2) 
    { 
    return strcmp(*(char **)e1, *(char **)e2); 
    } 
    
void main() 
    { 
    int arrayInt[] = { 39, 33, 18, 64, 73, 30, 49, 51, 81 }; 
    int numArray = sizeof(arrayInt) / sizeof(arrayInt[0]); 
    bubbleSort(arrayInt, numArray, sizeof(arrayInt[0]), compare_int); 
    for (int i = 0; i <numArray; i++) { 
    printf("%d ", arrayInt[i]); 
    } 
    printf("\n"); 
    
    bubbleSort(arrayInt, numArray, sizeof(arrayInt[0]), compare_int_r); 
    for (int i = 0; i <numArray; i++) { 
    printf("%d ", arrayInt[i]); 
    } 
    printf("\n"); 
    
    char * arrayStr[] = { "Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday" }; 
    numArray = sizeof(arrayStr) / sizeof(arrayStr[0]); 
    bubbleSort(arrayStr, numArray, sizeof(arrayStr[0]), compare_str); 
    for (int i = 0; i < numArray; i++) { 
    printf("%s\n", arrayStr[i]); 
    } 
    }    

    