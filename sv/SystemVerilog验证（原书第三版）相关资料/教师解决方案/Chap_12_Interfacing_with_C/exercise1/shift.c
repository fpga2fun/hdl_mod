/*///////////////////////////////////////////////////////////
// Purpose: C file for Chap_12_Interfacing_with_C/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.c,v $
// Revision 1.3  2011/09/24 20:31:51  tumbush.tumbush
// Pass in [31:0] as const svBitVecVal
//
// Revision 1.2  2011/09/23 21:20:31  tumbush.tumbush
// Updated names in C code function.
//
// Revision 1.1  2011/09/20 16:44:00  tumbush.tumbush
// Initial check-in.
//
//
///////////////////////////////////////////////////////////*/

// A positive value on n means to left shift i (multiply)
// A negative value on n means to right shift i (divide)
// n=0 means to return i
#include <stdio.h>
#include <svdpi.h>
int shift_c(const svBitVecVal *i, int n) 
{
  if (n < 0)
    return (*i >> (n *-1));
  else if (n > 0)
    return (*i << n);
  else
    return *i;

}


