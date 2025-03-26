////////////////////////////////////////////////////////////////////////////////
// Purpose: Top level module for Chap10_Advanced_Interfaces/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/09/16 21:37:18  tumbush.tumbush
// Moved from exercise5_6
//
//
///////////////////////////////////////////////////////////////////////////////
`default_nettype none
  parameter NUM_RISC_BUS = 3;
`include "risc_spm_if.sv"
  
  module top;

   bit clk;

   // Instantiate the risc_spm interface
   risc_spm_if risc_bus_array[NUM_RISC_BUS] (clk);
  
   // Instantiate the testbench
   test #(.NUM_RISC_BUS(NUM_RISC_BUS)) test();   


   // clocking
   always #50ns clk = !clk;
 
endmodule

