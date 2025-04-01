///////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_8_Advanced_OOP_and_Testbench_Guidelines/exercise6_7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/13 15:32:23  tumbush.tumbush
// Updated as per July 21, 2011 version of Chapter 8.
//
// Revision 1.1  2011/05/29 19:16:08  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/11 22:42:04  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;

   import my_package::*;

   ExtBinary mc, mc2;
   
   initial begin
      mc = new(15, 8);
      mc.print_int(mc.mult());
   
      if (!$cast(mc2, mc.copy()))
        $display("ERROR: cannot assign");
      else
        $display("Success");

      // Check that mc2 is equal to mc.
      if ((mc2.val1 !== mc.val1) || (mc2.val2 !== mc.val2))
        $display("member variables of mc2 != mc");
      else
	$display("member variables of mc2 == mc");
	
      // mc2 = mc.copy(); // Will result in a compile error

   end

endprogram
