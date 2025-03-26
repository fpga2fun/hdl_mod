////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/06 23:08:21  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:10:01  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:19:49  Greg
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
      repeat (100) begin
	 `SV_RAND_CHECK(MyMemTrans.randomize());
	 MyMemTrans.print_all();
      end
      $display("----------------");
      MyMemTrans = new;
      MyMemTrans.valid_rw_address.constraint_mode(0);
      repeat (100) begin
         `SV_RAND_CHECK(MyMemTrans.randomize() with {(rw == 0)->(address inside {[0:8]});});
         MyMemTrans.print_all();
      end
   end
   
endprogram

