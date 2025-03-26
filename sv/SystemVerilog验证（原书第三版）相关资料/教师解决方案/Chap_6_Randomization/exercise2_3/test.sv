////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise2_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/06 22:52:54  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:09:56  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 16:31:49  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;

   initial begin
      Exercise2 MyExercise2;
      repeat (20) begin
	 MyExercise2 = new;
	 `SV_RAND_CHECK (MyExercise2.randomize());
	 MyExercise2.print_all();
      end
   end
   
endprogram

