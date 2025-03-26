///////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_8_Advanced_OOP_and_Testbench_Guidelines/exercise1_2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/13 14:56:57  tumbush.tumbush
// Fixed typo in CVS log message
//
// Revision 1.2  2011/09/13 14:52:23  tumbush.tumbush
// Updated as per July 21, 2011 version of Chapter 8.
//
// Revision 1.1  2011/05/29 19:16:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/11 22:36:11  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;

   import my_package::*;

   ExtBinary mc;
   
   initial begin
      mc = new(15, 8);
      mc.print_int(mc.mult());
   end

endprogram
