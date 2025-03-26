/*///////////////////////////////////////////////////////////
// Purpose: C file for Chap_12_Interfacing_with_C/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.c,v $
// Revision 1.1  2011/09/27 17:23:22  tumbush.tumbush
// Initial check-in
//
//
///////////////////////////////////////////////////////////*/

#include <stdio.h>
#include <svdpi.h>
extern svBitVecVal shift_sv(const svBitVecVal *i, int);

svBitVecVal shift_c(const svBitVecVal *i, int n)
{
  return shift_sv(i, n);
}


