////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_7_Threads_and_Interprocess_Communicaton/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/29 19:13:47  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:26:07  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "my_if.sv"
  module top;

   bit clk;

   // Instantiate the my_if interface
   my_if my_bus(clk);

   // Instantiate testbench
   test test(my_bus.test);

   // Instantiate my
   dut dut(my_bus.dut);

   initial begin
      forever clk = #50ns !clk;
   end
   
endmodule

