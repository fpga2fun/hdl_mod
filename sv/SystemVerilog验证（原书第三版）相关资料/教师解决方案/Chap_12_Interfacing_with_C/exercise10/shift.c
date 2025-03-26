/*///////////////////////////////////////////////////////////
// Purpose: C file for Chap_12_Interfacing_with_C/exercise10
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.c,v $
// Revision 1.1  2011/09/27 19:15:24  tumbush.tumbush
// Initial check-in
//
//
///////////////////////////////////////////////////////////*/

#include <stdio.h>
#include <svdpi.h>
extern void shift_sv(int, const svBitVecVal*, int);
extern void shift_build();
extern void shift_print(int);

shift_c() {
  int shifted;
  int val;
  int 	      shift;
  int index;
 
  shift_build();
  shift_build();

  val = 1; shift = 1; index = 0;
  shift_sv(index, &val, shift);
  printf("%d shifted by %d = ", val, shift);
  shift_print(index);

  val = 2; shift = -1; index = 0;
  shift_sv(index, &val, shift);
  printf("%d shifted by %d = ", val, shift);
  shift_print(index);

  val = 2; shift = 0; index = 0;
  shift_sv(index, &val, shift);
  printf("%d shifted by %d = ", val, shift);
  shift_print(index);

  val = 512; shift = 1; index = 1;
  shift_sv(index, &val, shift);
  printf("%d shifted by %d = ", val, shift);
  shift_print(index);

  val = 1024; shift = -1; index = 1;
  shift_sv(index, &val, shift);
  printf("%d shifted by %d = ", val, shift);
  shift_print(index);

  val = 2048; shift = 0; index = 1;
  shift_sv(index, &val, shift);
  printf("%d shifted by %d = ", val, shift);
  shift_print(index);
  
}



