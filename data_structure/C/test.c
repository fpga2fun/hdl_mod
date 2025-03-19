#include <stdio.h>
#include <stdlib.h>

int compare_int(const void *e1, const void *e2) 
{ 
    return (*((int *)e1) - *((int *)e2)); 
}

int main() {
    int arr[] = {5, 2, 9, 1, 5, 6};
    int n = sizeof(arr) / sizeof(arr[0]);

    qsort(arr, n, sizeof(int), compare_int);

    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    return 0;
}