///////////////////////////////////////////////////////////////////////////////////////
// Purpose: Top level for Chap_4_Connecting_the_Testbench_and_Design/homework2_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/28 20:22:59  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 14:08:51  Greg
// Initial check in
//
///////////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "mem_if.sv"
module top;

   bit clk;

   // The interface
   mem_if mem_bus(clk);

   // The DUT
   my_mem my_mem(mem_bus.slave);

   // The test
   test test(mem_bus.master);

   // Create a clock
   initial begin
      clk = 1'b0;
      forever #50ns clk=!clk;
   end


endmodule // test

