/////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_6_Randomization/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/29 19:10:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:09:52  Greg
// Initial check in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "ahb_if.sv"
`include "sram_if.sv"
module top;

   bit clk;
   bit reset;
   
   // The ahb interface
   ahb_if ahb_bus(clk);

   // The sram interface
   sram_if sram_bus();
   
   // The test
   test test(.reset(reset), .ahb_bus(ahb_bus.master));

   // The SRAM model
   async async_sram (
		     .A(sram_bus.A),
		     .CE_b(sram_bus.CE_b),
		     .WE_b(sram_bus.WE_b), 
		     .OE_b(sram_bus.OE_b),
		     .DQ(sram_bus.DQ)
		     );

// The DUT
   sram_control sram_control(
			     .ahb_bus(ahb_bus.slave), 
			     .sram_bus(sram_bus.master), 
			     .reset(reset)
     );

   // Create a clock
   initial begin
      clk = 1'b0;
      forever #50ns clk=!clk;
   end


endmodule // test

