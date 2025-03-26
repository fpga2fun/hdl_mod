/*///////////////////////////////////////////////////////////
// Purpose: C file for Chap_12_Interfacing_with_C/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.c,v $
// Revision 1.1  2011/09/27 17:10:17  tumbush.tumbush
// Initial check-in
//
//
///////////////////////////////////////////////////////////*/

#include <stdio.h>
#include <svdpi.h>
#include <malloc.h>

typedef struct { /* Structure to hold call count and internal_reg */
  unsigned int call_cnt;
  int internal_reg;
} shift_cnt;

shift_cnt *shift_cnt_ptr;

/* Construct a counter structure */
void* shift_new() {
  shift_cnt_ptr = malloc(sizeof(shift_cnt));
  shift_cnt_ptr->call_cnt = 0;
  shift_cnt_ptr->internal_reg = 0;
  return shift_cnt_ptr;
}


// Assuming that a positive value on shift means to left shift (multiply)
// and a negative value on shift means to right shift (divide)
int shift_c(const svBitVecVal *i, int n, svBit ld, shift_cnt *inst) 
{

  // printf("C: i=%d, n=%d, ld=%d\n", *i, n, ld);

  if (ld) {
    if (n < 0)
      inst->internal_reg =  (*i >> (n *-1));
    else if (n > 0)
      inst->internal_reg =  (*i << n);
    else
      inst->internal_reg = *i;
  }
  else {
    if (n < 0)
      inst->internal_reg =  (inst->internal_reg >> (n *-1));
    else if (n > 0)
      inst->internal_reg =  (inst->internal_reg << n);
  }

  // printf("C: inst->internal_reg = %d\n", inst->internal_reg);

  printf("Instance address %d, function call %d: %d shifted by %d = %d, load = %d\n", inst, inst->call_cnt++, *i, n, inst->internal_reg, ld);

  return inst->internal_reg;	 


}


