////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/06 22:56:12  tumbush.tumbush
// Corrected spelling of SV_RAND_CHECK
//
// Revision 1.2  2011/09/06 22:54:13  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:09:59  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 18:55:32  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;

   initial begin
      Stim MyStim;
      
      $display("---- congestion_test = 0----");
      repeat (20) begin
	 MyStim = new;
	 MyStim.congestion_test = 0;
	 `SV_RAND_CHECK(MyStim.randomize());
	 MyStim.print_all();
      end

      $display("---- congestion_test = 1----");
      repeat (20) begin
	 MyStim = new;
	 MyStim.congestion_test = 1;
	 `SV_RAND_CHECK(MyStim.randomize());
	 MyStim.print_all();
      end
 
      
   end
   
endprogram

