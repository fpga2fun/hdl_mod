/*///////////////////////////////////////////////////////////
// Purpose: C file for Chap_12_Interfacing_with_C/exercise2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.c,v $
// Revision 1.3  2011/09/24 20:20:26  tumbush.tumbush
// Initial check-in
//
//
///////////////////////////////////////////////////////////*/

// A positive value on n means to left shift i (multiply)
// A negative value on n means to right shift i (divide)
// n=0 means to return i
// When ld is true, i is shifted n places and then loaded 
// into an internal 32-bit register. When ld is false, the 
// register is shifted n places.
#include <stdio.h>
#include <svdpi.h>
int shift_c(const svBitVecVal *i, int n, svBit ld) 
{
  static int internal_reg;

  // printf("C: i=%d, n=%d, ld=%d\n", *i, n, ld);

  if (ld) {
    if (n < 0)
      internal_reg =  (*i >> (n *-1));
    else if (n > 0)
      internal_reg =  (*i << n);
    else
      internal_reg = *i;
  }
  else {
    if (n < 0)
      internal_reg =  (internal_reg >> (n *-1));
    else if (n > 0)
      internal_reg =  (internal_reg << n);
  }
  // printf("C: internal_reg = %d\n", internal_reg);
  return internal_reg;
}


