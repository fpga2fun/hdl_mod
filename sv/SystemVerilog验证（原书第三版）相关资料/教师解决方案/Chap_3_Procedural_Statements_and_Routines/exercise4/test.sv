////////////////////////////////////////////////////////////////////////////
// Purpose: Solution for Chap_3_Procedural_Statements_and_Routines/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:06:46  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 20:45:12  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////
`timescale 1fs/1fs
`default_nettype none
module test;

   initial begin
      $timeformat(-12, 2, "ps", 0);
      $display("time = %0t", 12.95ps);
      $finish;
   end

endmodule // test

