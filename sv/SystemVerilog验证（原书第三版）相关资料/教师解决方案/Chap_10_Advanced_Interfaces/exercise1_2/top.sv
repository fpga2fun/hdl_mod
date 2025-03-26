////////////////////////////////////////////////////////////////////////////
// Purpose: Top level testbench for Chap_10_Advanced_Interfaces/exercise1_2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.2  2011/09/17 20:40:33  tumbush.tumbush
// Don't use typedef for mailbox
//
// Revision 1.1  2011/05/27 02:45:19  tumbush.tumbush
// Checked into cloud
//
// Revision 1.1  2011/05/15 19:56:22  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "risc_spm_if.sv"
  
  module top;

   bit clk;

   // Instantiate the risc_spm interface
   risc_spm_if risc_bus(clk);
  
   // Instantiate the testbench
   test test(risc_bus);   


   // clocking
   always #50ns clk = !clk;
 
endmodule

