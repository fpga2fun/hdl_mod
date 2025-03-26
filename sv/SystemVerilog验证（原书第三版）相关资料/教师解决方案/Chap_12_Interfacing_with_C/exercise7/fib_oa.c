/*///////////////////////////////////////////////////////////
// Purpose: C++ file for Chap_12_Interfacing_with_C/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: fib_oa.c,v $
// Revision 1.2  2011/09/27 17:21:37  tumbush.tumbush
// Added header information
//
//
///////////////////////////////////////////////////////////*/

#include <svdpi.h>
#include <stdio.h>
void mydisplay(const svOpenArrayHandle h) {
  int i, j;
  int lo1 = svLow(h, 1);
  int hi1 = svHigh(h, 1);
  int lo2 = svLow(h, 2);
  int hi2 = svHigh(h, 2);
  for (i=lo1; i<=hi1; i++) {
    for (j=lo2; j<=hi2; j++) {
      int *a = (int*) svGetArrElemPtr2(h, i, j);
      printf("C: a[%d][%d] = %d\n", i, j, *a);
      *a = i * j;
    }
  }

  printf("Left bound for dimension 0 = %d\n", svLeft(h, 1));
  printf("Left bound for dimension 1 = %d\n", svLeft(h, 2));
  printf("Right bound for dimension 0 = %d\n", svRight(h, 1));
  printf("Right bound for dimension 1 = %d\n", svRight(h, 2));
  printf("Size for dimension 0 = %d\n", svSize(h, 1));
  printf("Size for dimension 1 = %d\n", svSize(h, 2));
  printf("Dimensions of array = %d\n", svDimensions(h));
  printf("Size of array in bytes = %d\n", svSizeOfArray(h));


}
