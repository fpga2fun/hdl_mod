////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise1_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/06 22:49:46  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:09:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.2  2011/05/10 16:25:08  Greg
// Replaced MemTrans with Exercise1. Replaced data_in with data
//
// Revision 1.1  2011/05/10 16:20:24  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;

   initial begin
      Exercise1 MyExercise1;
      repeat (20) begin
	 MyExercise1 = new;
	 `SV_RAND_CHECK(MyExercise1.randomize());
	 MyExercise1.print_all();
      end
   end
   
endprogram

