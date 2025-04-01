////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise10
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/06 23:11:52  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.2  2011/09/06 18:54:48  tumbush.tumbush
// Generate 20 transactions.
//
// Revision 1.1  2011/05/29 19:09:53  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 20:04:07  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;
   Transaction t;
   
   initial begin
      t=new();
      for (int i=0;i<20;i++) begin
	 `SV_RAND_CHECK(t.randomize());
	 t.print_all;
	 #10ns;
      end
   end
   
endprogram

