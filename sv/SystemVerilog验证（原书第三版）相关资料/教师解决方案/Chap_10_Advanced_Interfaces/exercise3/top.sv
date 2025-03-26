////////////////////////////////////////////////////////////////////////////
// Purpose: Top level testbench for Chap_10_Advanced_Interfaces/exercise3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/09/16 21:24:10  tumbush.tumbush
// Moved from exercise3_4
//
//
////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "risc_spm_if.sv"
  
  module top;

   bit clk;

   // Instantiate the risc_spm interface
   risc_spm_if risc_bus(clk);
  
   // Instantiate the testbench
   test test();   


   // clocking
   always #50ns clk = !clk;
 
endmodule

