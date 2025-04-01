////////////////////////////////////////////////////////////////////////////
// Purpose: Top level testbench for Chap_10_Advanced_Interfaces/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/09/16 21:44:54  tumbush.tumbush
// Moved from exercise8
//
//
////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "risc_spm_if.sv"
  
  module top;

   bit clk;

   parameter ADDRESS_WIDTH = 9;

   // Instantiate the risc_spm interface
   risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus(clk);
  
   // Instantiate the testbench
   test #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) test();   


   // clocking
   always #50ns clk = !clk;
 
endmodule

