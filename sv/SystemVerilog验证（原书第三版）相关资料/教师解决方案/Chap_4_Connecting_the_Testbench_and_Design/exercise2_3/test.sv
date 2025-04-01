////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_4_Connecting_the_Testbench_and_Design/exercise2_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:22:56  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:18:18  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "reg_if.sv"
module test;


   bit clk;

   always #50ns clk = !clk;

   reg_if reg_bus(clk);

   my_reg my_reg (reg_bus.slave);

   no_program no_program(reg_bus.master);
  		    
endmodule
