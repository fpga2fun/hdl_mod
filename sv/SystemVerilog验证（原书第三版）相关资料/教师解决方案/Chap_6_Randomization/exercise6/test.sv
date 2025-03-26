////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/08 17:23:10  tumbush.tumbush
// Remove $ from inside constraint.
//
// Revision 1.1  2011/05/29 19:10:00  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:08:09  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;

   initial begin
      MemTrans MyMemTrans;
      MyMemTrans = new;
      repeat (10000) begin
	 `SV_RAND_CHECK(MyMemTrans.randomize());
	 MyMemTrans.print_all();
      end
   end
   
endprogram

