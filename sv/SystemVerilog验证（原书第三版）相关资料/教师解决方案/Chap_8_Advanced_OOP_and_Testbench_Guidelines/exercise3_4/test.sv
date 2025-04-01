///////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_8_Advanced_OOP_and_Testbench_Guidelines/exercise3_4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.4  2011/09/13 17:32:57  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.3  2011/09/13 14:56:19  tumbush.tumbush
// Fixed typo in log message.
//
// Revision 1.2  2011/09/13 14:55:41  tumbush.tumbush
// Updated as per July 21, 2011 version of Chapter 8.
//
// Revision 1.1  2011/05/29 19:16:05  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/11 22:38:28  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;

   import my_package::*;

   ExtBinary mc;
   
   initial begin
      mc = new(15, 8);
      mc.print_int(mc.mult());
      `SV_RAND_CHECK(mc.randomize());
      mc.print_int(mc.val1);
      mc.print_int(mc.val2);
      mc.print_int(mc.mult());
   end

endprogram
