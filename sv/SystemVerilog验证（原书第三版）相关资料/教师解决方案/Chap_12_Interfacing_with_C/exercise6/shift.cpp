/*///////////////////////////////////////////////////////////
// Purpose: C++ file for Chap_12_Interfacing_with_C/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.cpp,v $
// Revision 1.2  2011/09/27 18:40:40  tumbush.tumbush
// Enhanced information displayed.
//
// Revision 1.1  2011/09/27 17:18:00  tumbush.tumbush
// Initial check-in
//
//
//
///////////////////////////////////////////////////////////*/

#include <stdio.h>
#include <svdpi.h>


class shift_cnt{
public:
  shift_cnt(unsigned int); // Constructor
  int shift_signal(const svBitVecVal*, int, svBit);

private:
  unsigned int call_cnt;
  int internal_reg;
};


/* Construct a counter structure */
shift_cnt::shift_cnt(unsigned int start_val)
{
  call_cnt = 0;
  internal_reg = start_val;
}

/* Run the counter for one cycle */
int shift_cnt::shift_signal(const svBitVecVal *i, int n, svBit ld) 
{

  int old_internal_reg = internal_reg;

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

  if (ld)
    printf("function call %d: %d shifted by %d = %d, load = %d\n", call_cnt++, *i, n, internal_reg, ld);
  else
    printf("function call %d: %d shifted by %d = %d, load = %d\n", call_cnt++, old_internal_reg, n, internal_reg, ld);

  return internal_reg;	 


}


extern "C" void* shift_new(unsigned int start_val) 
{
  return new shift_cnt(start_val);
}

extern "C" int shift_c(const svBitVecVal *i, int n, svBit ld, shift_cnt *inst)
{
  shift_cnt *hc = (shift_cnt *) inst;
  printf("Instance address %d ", inst);
  hc->shift_signal(i, n, ld);
}

