///////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/06 23:10:50  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.2  2011/09/06 18:53:25  tumbush.tumbush
// Generate 20 transactions and print out the size of each transaction.
//
// Revision 1.1  2011/05/29 19:10:03  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:56:06  Greg
// Initial check-in
//
//////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;
   StimData my_data;
   
   initial begin
      for (int i=0;i<20;i++) begin
	 my_data=new();
	 `SV_RAND_CHECK(my_data.randomize());
	 my_data.print_size;
      end
      /*
      for (int i=0;i<=10;i++)
	my_data.print_element(i);
       */
   end

endprogram

