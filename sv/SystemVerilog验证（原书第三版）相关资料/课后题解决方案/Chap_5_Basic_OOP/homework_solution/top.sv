///////////////////////////////////////////////////////////////////////
// Purpose: Top level testbench for Chap_5_Basic_OOP/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/29 19:03:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:02:27  Greg
// Initial check in
//
//////////////////////////////////////////////////////////////////////
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

