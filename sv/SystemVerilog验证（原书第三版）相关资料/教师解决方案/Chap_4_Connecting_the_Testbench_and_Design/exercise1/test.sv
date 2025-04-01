////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_4_Connecting_the_Testbench_and_Design/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:22:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:13:59  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "ahb_if.sv"
  
  module test;   
   ahb_if ahb_bus();
   ahb_slave ahb_slave(ahb_bus.slave);
   ahb_master ahb_master(ahb_bus);
  endmodule
