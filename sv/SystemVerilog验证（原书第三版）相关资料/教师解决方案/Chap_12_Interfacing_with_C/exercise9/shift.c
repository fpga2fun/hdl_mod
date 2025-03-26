/*///////////////////////////////////////////////////////////
// Purpose: C file for Chap_12_Interfacing_with_C/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.c,v $
// Revision 1.3  2011/09/27 19:20:29  tumbush.tumbush
// Initial check-in
//
//
///////////////////////////////////////////////////////////*/

#include <stdio.h>
#include <svdpi.h>
extern int shift_sv(int, const svBitVecVal*, int);
extern void shift_build();

// Note: Only the C-code is required for exercise 9
shift_c() {
  int shifted;
  int val;
  int 	      shift;
  int index;
 
  shift_build();
  shift_build();

  val = 1; shift = 1; index = 0;
  shifted = shift_sv(index, &val, shift);
  printf("%d shifted by %d = %d\n", val, shift, shifted);

  val = 2; shift = -1; index = 0;
  shifted = shift_sv(index, &val, shift);
  printf("%d shifted by %d = %d\n", val, shift, shifted);

  val = 2; shift = 0; index = 0;
  shifted = shift_sv(index, &val, shift);
  printf("%d shifted by %d = %d\n", val, shift, shifted);

  val = 512; shift = 1; index = 1;
  shifted = shift_sv(index, &val, shift);
  printf("%d shifted by %d = %d\n", val, shift, shifted);

  val = 1024; shift = -1; index = 1;
  shifted = shift_sv(index, &val, shift);
  printf("%d shifted by %d = %d\n", val, shift, shifted);

  val = 2048; shift = 0; index = 1;
  shifted = shift_sv(index, &val, shift);
  printf("%d shifted by %d = %d\n", val, shift, shifted);

  
}



